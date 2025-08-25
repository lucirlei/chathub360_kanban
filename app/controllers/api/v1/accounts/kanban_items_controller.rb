class Api::V1::Accounts::KanbanItemsController < Api::V1::Accounts::BaseController
  before_action :fetch_kanban_item, except: [:index, :create, :reorder, :debug]
  before_action :check_stacklab_license, except: [:debug]

  def index
    authorize KanbanItem

    # Permitir explicitamente os parâmetros de filtro
    permitted_params = index_params

    # Memoizar parâmetros processados
    @funnel_id ||= permitted_params[:funnel_id]
    @stage_id ||= permitted_params[:stage_id]
    @agent_id ||= permitted_params[:agent_id]
    @page ||= permitted_params[:page].to_i > 0 ? permitted_params[:page].to_i : 1
    @limit ||= 50

    # Cache inteligente baseado nos parâmetros de filtro e paginação
    cache_key = [
      'kanban_items_index',
      Current.account.id,
      @funnel_id,
      @stage_id,
      @agent_id,
      @page,
      @limit
    ]

    @kanban_items_data = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      # Memoizar queries dentro do bloco de cache
      @base_query ||= build_base_query
      @items_query ||= build_items_query

      # Aplicar paginação
      @items ||= fetch_paginated_items

      # Verificar se há mais itens
      @pagination_data ||= build_pagination_data

      # Serialização dos itens paginados com metadados
      {
        items: @items.map(&:as_json),
        pagination: @pagination_data
      }
    end

    render json: @kanban_items_data
  end

  def show
    # authorize @kanban_item

    # Cache baseado no id e updated_at
    @kanban_item_data = Rails.cache.fetch([@kanban_item.id, @kanban_item.updated_at.to_i]) do
      @kanban_item.as_json
    end

    render json: @kanban_item_data
  end

  def create
    @kanban_item = Current.account.kanban_items.new(kanban_item_params)

    # Se houver um conversation_id nos item_details, define o conversation_display_id
    @kanban_item.conversation_display_id = @kanban_item.item_details['conversation_id'] if @kanban_item.item_details['conversation_id'].present?

    authorize @kanban_item

    if @kanban_item.save
      # Invalidar cache da listagem para o funil do novo item
      invalidate_listing_cache(nil, @kanban_item.funnel_stage)
      webhook_service.notify_item_created(@kanban_item)
      render json: @kanban_item
    else
      render json: { errors: @kanban_item.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize @kanban_item

    # Capturar mudanças antes de salvar
    changes = {}
    kanban_item_params.each do |key, value|
      next unless @kanban_item.send(key) != value

      changes[key] = {
        from: @kanban_item.send(key),
        to: value
      }
    end

    @kanban_item.assign_attributes(kanban_item_params)

    if @kanban_item.save
      # Invalidar cache da listagem para o funil do item atualizado
      invalidate_listing_cache(nil, @kanban_item.funnel_stage)
      webhook_service.notify_item_updated(@kanban_item, changes) if changes.present?
      render json: @kanban_item
    else
      render json: { errors: @kanban_item.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @kanban_item
    item_data = @kanban_item.dup
    @kanban_item.destroy!
    # Invalidar cache da listagem para o funil do item deletado
    invalidate_listing_cache(nil, item_data.funnel_stage)
    webhook_service.notify_item_deleted(item_data)
    head :ok
  end

  def move_to_stage
    authorize @kanban_item, :move_to_stage?
    from_stage = @kanban_item.funnel_stage
    @kanban_item.funnel_id = params[:funnel_id] if params[:funnel_id].present?
    @kanban_item.move_to_stage(params[:funnel_stage])
    @kanban_item.save! if @kanban_item.changed?

    # Invalidar cache do item individual
    Rails.cache.delete([@kanban_item.id, @kanban_item.updated_at.to_i])

    # Invalidar cache da listagem para os funis/stages afetados
    invalidate_listing_cache(from_stage, params[:funnel_stage])

    webhook_service.notify_stage_change(@kanban_item, from_stage, params[:funnel_stage])
    head :ok
  end

  def reorder
    authorize KanbanItem, :reorder?

    # Capturar estado atual antes das mudanças
    current_items = Current.account.kanban_items.where(id: params[:positions].map { |p| p[:id] })
    changes = params[:positions].map do |position|
      current_item = current_items.find { |item| item.id == position[:id].to_i }
      {
        item_id: position[:id],
        old_position: current_item&.position,
        new_position: position[:position],
        old_stage: current_item&.funnel_stage,
        new_stage: position[:funnel_stage]
      }
    end

    ActiveRecord::Base.transaction do
      params[:positions].each do |position|
        item = Current.account.kanban_items.find(position[:id])
        item.update!(
          position: position[:position],
          funnel_stage: position[:funnel_stage]
        )
        # O updated_at é atualizado automaticamente, invalidando o cache
      end
    end

    # Notificar webhook após a reordenação
    updated_items = Current.account.kanban_items.where(id: params[:positions].map { |p| p[:id] })
    webhook_service.notify_item_reordered(updated_items, changes)

    # Invalidar cache da listagem para todos os funis afetados
    funnel_ids = updated_items.pluck(:funnel_id).uniq
    funnel_ids.each do |funnel_id|
      Rails.cache.delete(['kanban_items_index', Current.account.id, funnel_id, nil, nil, 1, 50])
      # Invalidar caches de outras páginas (páginas 2-10)
      (2..10).each do |page|
        Rails.cache.delete(['kanban_items_index', Current.account.id, funnel_id, nil, nil, page, 50])
      end
    end

    head :ok
  end

  def debug
    authorize KanbanItem
    funnel_id = params[:funnel_id]

    kanban_items = Current.account.kanban_items
                          .for_funnel(funnel_id)
                          .order_by_position

    debug_info = {
      environment: Rails.env,
      ruby_version: RUBY_VERSION,
      rails_version: Rails::VERSION::STRING,
      kanban_items_count: kanban_items.size,
      first_item_sample: kanban_items.first&.as_json,
      has_conversation_data: kanban_items.any? { |item| item.item_details['conversation_id'].present? }
    }

    render json: debug_info
  end

  # Método simples para mover o item
  def move
    authorize @kanban_item
    old_funnel_id = @kanban_item.funnel_id
    old_stage = @kanban_item.funnel_stage

    @kanban_item.update!(
      funnel_id: params[:funnel_id],
      funnel_stage: params[:funnel_stage]
    )

    # Invalidar cache do item individual
    Rails.cache.delete([@kanban_item.id, @kanban_item.updated_at.to_i])

    # Invalidar cache da listagem para os funis/stages afetados
    invalidate_listing_cache(old_stage, params[:funnel_stage])

    render json: @kanban_item
  end

  # Método para criar item na checklist
  def create_checklist_item
    authorize @kanban_item
    checklist = @kanban_item.checklist || []
    checklist << {
      id: SecureRandom.uuid,
      text: params[:text],
      completed: false,
      created_at: Time.current,
      position: checklist.size
    }
    @kanban_item.checklist = checklist
    @kanban_item.save!

    # Invalidar cache do item individual
    Rails.cache.delete([@kanban_item.id, @kanban_item.updated_at.to_i])

    # Invalidar cache da listagem para o funil do item
    invalidate_listing_cache(nil, @kanban_item.funnel_stage)

    render json: @kanban_item
  end

  # Método para criar nota
  def create_note
    authorize @kanban_item
    notes = @kanban_item.item_details['notes'] || []
    notes << {
      id: SecureRandom.uuid,
      text: params[:text],
      created_at: Time.current,
      author: Current.user.name,
      author_id: Current.user.id
    }
    @kanban_item.item_details['notes'] = notes
    @kanban_item.save!

    # Invalidar cache do item individual
    Rails.cache.delete([@kanban_item.id, @kanban_item.updated_at.to_i])

    # Invalidar cache da listagem para o funil do item
    invalidate_listing_cache(nil, @kanban_item.funnel_stage)

    render json: @kanban_item
  end

  # Método para atribuir agente (atualizado para múltiplos agentes)
  def assign_agent
    authorize @kanban_item

    agent_id = params[:agent_id]

    unless agent_id.present?
      render json: { error: 'agent_id is required' }, status: :bad_request
      return
    end

    if @kanban_item.assign_agent(agent_id, Current.user)
      # Invalidar cache do item individual
      Rails.cache.delete([@kanban_item.id, @kanban_item.updated_at.to_i])

      # Invalidar cache da listagem filtrada por agente
      invalidate_agent_filtered_cache(agent_id)

      render json: @kanban_item
    else
      render json: { error: 'Failed to assign agent or agent already assigned' }, status: :unprocessable_entity
    end
  end

  # Método para remover agente
  def remove_agent
    authorize @kanban_item

    agent_id = params[:agent_id]

    unless agent_id.present?
      render json: { error: 'agent_id is required' }, status: :bad_request
      return
    end

    if @kanban_item.remove_agent(agent_id)
      # Invalidar cache do item individual
      Rails.cache.delete([@kanban_item.id, @kanban_item.updated_at.to_i])

      # Invalidar cache da listagem filtrada por agente
      invalidate_agent_filtered_cache(agent_id)

      render json: @kanban_item
    else
      render json: { error: 'Failed to remove agent or agent not found' }, status: :unprocessable_entity
    end
  end

  # Método para listar agentes atribuídos
  def assigned_agents
    authorize @kanban_item

    render json: {
      assigned_agents: @kanban_item.assigned_agents_data,
      primary_agent: @kanban_item.primary_agent&.as_json(only: %i[id name email avatar_url availability_status])
    }
  end

  # Método para mudar status
  def change_status
    authorize @kanban_item

    status = params[:status]
    allowed_statuses = %w[won lost open]

    unless allowed_statuses.include?(status)
      render json: { error: "Status must be one of: #{allowed_statuses.join(', ')}" }, status: :unprocessable_entity
      return
    end

    @kanban_item.item_details['status'] = status
    @kanban_item.save!

    # Invalidar cache do item individual
    Rails.cache.delete([@kanban_item.id, @kanban_item.updated_at.to_i])

    # Invalidar cache da listagem para o funil do item
    invalidate_listing_cache(nil, @kanban_item.funnel_stage)

    render json: @kanban_item
  end

  # Método para atribuir agente a um item específico do checklist
  def assign_agent_to_checklist_item
    authorize @kanban_item

    checklist_item_id = params[:checklist_item_id]
    agent_id = params[:agent_id]

    # Validar parâmetros
    unless checklist_item_id.present? && agent_id.present?
      render json: { error: 'checklist_item_id and agent_id are required' }, status: :bad_request
      return
    end

    # Buscar o item do checklist
    checklist = @kanban_item.checklist || []
    checklist_item = checklist.find { |item| item['id'] == checklist_item_id }

    unless checklist_item
      render json: { error: 'Checklist item not found' }, status: :not_found
      return
    end

    # Atualizar o agente do item
    checklist_item['agent_id'] = agent_id
    checklist_item['updated_at'] = Time.current

    # Salvar as alterações
    @kanban_item.checklist = checklist
    @kanban_item.save!

    # Invalidar cache do item individual
    Rails.cache.delete([@kanban_item.id, @kanban_item.updated_at.to_i])

    # Invalidar cache da listagem filtrada por agente
    invalidate_agent_filtered_cache(agent_id)

    render json: @kanban_item
  end

  # Método para remover agente de um item específico do checklist
  def remove_agent_from_checklist_item
    authorize @kanban_item

    checklist_item_id = params[:checklist_item_id]

    # Validar parâmetros
    unless checklist_item_id.present?
      render json: { error: 'checklist_item_id is required' }, status: :bad_request
      return
    end

    # Buscar o item do checklist
    checklist = @kanban_item.checklist || []
    checklist_item = checklist.find { |item| item['id'] == checklist_item_id }

    unless checklist_item
      render json: { error: 'Checklist item not found' }, status: :not_found
      return
    end

    # Capturar o agent_id antes de remover para invalidar o cache
    agent_id = checklist_item['agent_id']

    # Remover o agente do item
    checklist_item.delete('agent_id')
    checklist_item['updated_at'] = Time.current

    # Salvar as alterações
    @kanban_item.checklist = checklist
    @kanban_item.save!

    # Invalidar cache do item individual
    Rails.cache.delete([@kanban_item.id, @kanban_item.updated_at.to_i])

    # Invalidar cache da listagem filtrada por agente (se havia um agente)
    invalidate_agent_filtered_cache(agent_id) if agent_id.present?

    render json: @kanban_item
  end

  private

  def webhook_service
    @webhook_service ||= KanbanWebhookService.new(Current.account)
  end

  def fetch_kanban_item
    @kanban_item = Current.account.kanban_items.find(params[:id])
  end

  def build_base_query
    query = Current.account.kanban_items.for_funnel(@funnel_id)
    query = query.in_stage(@stage_id) if @stage_id.present?
    query = query.assigned_to_agent(@agent_id) if @agent_id.present?
    query
  end

  def build_items_query
    @base_query.includes(:attachments_attachments, :funnel, :conversation).order_by_position
  end

  def fetch_paginated_items
    offset = (@page - 1) * @limit
    @items_query.limit(@limit).offset(offset).to_a
  end

  def build_pagination_data
    total_count = @base_query.count
    offset = (@page - 1) * @limit
    has_more = (offset + @items.length) < total_count

    {
      current_page: @page,
      total_count: total_count,
      has_more: has_more,
      items_per_page: @limit
    }
  end

  def invalidate_listing_cache(from_stage, to_stage)
    # Invalidar cache para o funil atual do item
    funnel_id = @kanban_item.funnel_id

    # Invalidar cache da listagem principal (sem filtros específicos)
    Rails.cache.delete(['kanban_items_index', Current.account.id, nil, nil, nil, 1, 50])

    # Invalidar cache para o funil específico
    Rails.cache.delete(['kanban_items_index', Current.account.id, funnel_id, nil, nil, 1, 50])

    # Invalidar cache para o stage de origem
    Rails.cache.delete(['kanban_items_index', Current.account.id, funnel_id, from_stage, nil, 1, 50])

    # Invalidar cache para o stage de destino
    Rails.cache.delete(['kanban_items_index', Current.account.id, funnel_id, to_stage, nil, 1, 50])

    # Invalidar caches de outras páginas (páginas 2-10 para cobrir a maioria dos casos)
    (2..10).each do |page|
      Rails.cache.delete(['kanban_items_index', Current.account.id, nil, nil, nil, page, 50])
      Rails.cache.delete(['kanban_items_index', Current.account.id, funnel_id, nil, nil, page, 50])
      Rails.cache.delete(['kanban_items_index', Current.account.id, funnel_id, from_stage, nil, page, 50])
      Rails.cache.delete(['kanban_items_index', Current.account.id, funnel_id, to_stage, nil, page, 50])
    end
  end

  def invalidate_agent_filtered_cache(agent_id)
    return unless agent_id.present?

    # Invalidar cache da listagem filtrada por agente específico
    Rails.cache.delete(['kanban_items_index', Current.account.id, nil, nil, agent_id, 1, 50])

    # Invalidar cache para diferentes funis e stages com filtro de agente
    funnel_id = @kanban_item.funnel_id
    Rails.cache.delete(['kanban_items_index', Current.account.id, funnel_id, nil, agent_id, 1, 50])

    # Invalidar caches de outras páginas (páginas 2-10)
    (2..10).each do |page|
      Rails.cache.delete(['kanban_items_index', Current.account.id, nil, nil, agent_id, page, 50])
      Rails.cache.delete(['kanban_items_index', Current.account.id, funnel_id, nil, agent_id, page, 50])
    end
  end

  def check_stacklab_license
    # Verifica se o token é válido (mesmo que não seja plano PRO)
    if ChatwootApp.stacklab.token_valid?
      # Se o token é válido mas não é plano PRO, retorna erro específico
      unless ChatwootApp.stacklab?
        render json: {
          error: 'Plano StackLab insuficiente',
          code: 'STACKLAB_PLAN_INSUFFICIENT',
          message: "Esta funcionalidade requer um plano PRO. Plano atual: #{ChatwootApp.stacklab.plan}. #{ChatwootApp.stacklab.message}"
        }, status: :forbidden
        return
      end
      return # Token válido e plano PRO
    end

    # Token inválido ou não configurado
    render json: {
      error: 'Token StackLab não encontrado',
      code: 'STACKLAB_TOKEN_NOT_FOUND',
      message: 'Esta funcionalidade requer uma licença StackLab válida'
    }, status: :not_found
  end

  def index_params
    params.permit(
      :funnel_id,
      :stage_id,
      :agent_id,
      :page,
      :from,
      :to,
      :inbox_id,
      user_ids: []
    )
  end

  def kanban_item_params
    params.require(:kanban_item).permit(
      :funnel_id,
      :funnel_stage,
      :position,
      :conversation_display_id,
      :timer_started_at,
      :timer_duration,
      :checklist,
      { checklist: [
        :id, :text, :completed, :created_at, :updated_at, :agent_id, :position
      ] },
      :assigned_agents,
      custom_attributes: {
        name: [],
        value: [],
        type: []
      },
      item_details: [
        :title,
        :description,
        :status,
        :reason,
        :priority,
        :value,
        :currency,
        { currency: [:symbol, :code, :locale] },
        { custom_attributes: [
          :name,
          :value,
          :type
        ] },
        { offers: [
          :value,
          { currency: [:symbol, :code, :locale] },
          :description
        ] },
        :deadline_at,
        :scheduling_type,
        :scheduled_at,
        { activities: [
          :id, :type,
          { user: [:id, :name, :avatar_url] },
          { details: [
            { user: [:id, :name, :avatar_url] },
            :new_stage, :old_stage
          ] },
          :created_at
        ] },
        :conversation_id,
        { notes: [
          :id, :text, :created_at,
          { attachments: [
            :id, :url, :filename, :byte_size, :content_type, :created_at
          ] },
          :linked_item_id, :linked_conversation_id, :linked_contact_id, :author, :author_id, :author_avatar
        ] }
      ]
    )
  end
end
