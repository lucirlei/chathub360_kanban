class Api::V1::Accounts::KanbanItemsController < Api::V1::Accounts::BaseController
  before_action :fetch_kanban_item, except: [:index, :create, :reorder, :debug]

  def index
    authorize KanbanItem
    funnel_id = params[:funnel_id]

    # Buscando os itens do funnel
    items = Current.account.kanban_items
                   .for_funnel(funnel_id)
                   .includes(:attachments_attachments, :funnel, :conversation)
                   .order_by_position
                   .to_a

    # Aplicando cache em cada item individualmente
    @kanban_items_data = items.map do |item|
      Rails.cache.fetch([item.id, item.updated_at.to_i]) do
        # Serialização do item quando não estiver em cache
        item.as_json
      end
    end

    render json: @kanban_items_data
  end

  def show
    authorize @kanban_item

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
      render json: @kanban_item
    else
      render json: { errors: @kanban_item.errors }, status: :unprocessable_entity
    end
  end

  def update
    authorize @kanban_item

    @kanban_item.assign_attributes(kanban_item_params)

    if @kanban_item.save
      render json: @kanban_item
    else
      render json: { errors: @kanban_item.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @kanban_item
    @kanban_item.destroy!
    head :ok
  end

  def move_to_stage
    authorize @kanban_item, :move_to_stage?
    @kanban_item.funnel_id = params[:funnel_id] if params[:funnel_id].present?
    @kanban_item.move_to_stage(params[:funnel_stage])
    @kanban_item.save! if @kanban_item.changed?
    head :ok
  end

  def reorder
    authorize KanbanItem, :reorder?

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

  private

  def fetch_kanban_item
    @kanban_item = Current.account.kanban_items.find(params[:id])
  end

  def kanban_item_params
    params.require(:kanban_item).permit(
      :funnel_id,
      :funnel_stage,
      :position,
      :conversation_display_id,
      :timer_started_at,
      :timer_duration,
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
        :agent_id,
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
        ] },
        { checklist: [
          :id, :text, :completed, :created_at, :updated_at, :position, :author, :author_id, :author_avatar
        ] }
      ]
    )
  end
end
