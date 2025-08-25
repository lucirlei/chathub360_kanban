class AutoCreateItemJob < ApplicationJob
  queue_as :default

  def perform(conversation_id)
    conversation = Conversation.find(conversation_id)

    # Verificação de existência global, antes de qualquer iteração.
    # Garante que um item de Kanban seja criado apenas uma vez por conversa.
    return if ::KanbanItem.exists?(conversation_display_id: conversation.display_id)

    account = conversation.account

    account.funnels.active.each do |funnel|
      next unless funnel.stages.present?

      funnel.stages.each do |stage_id, stage|
        next unless should_create_kanban_item?(conversation, stage)

        create_kanban_item(conversation, funnel, stage_id, stage)
      end
    end
  end

  private

  def should_create_kanban_item?(conversation, stage)
    # Verifica se tem condições de auto_criação
    return false unless stage['auto_create_conditions'].present?

    # Cria uma cópia das condições para não modificar o original
    conditions = stage['auto_create_conditions'].dup

    # Se o stage tem inbox_id configurado, adiciona a condição inbox_matches automaticamente
    if stage['inbox_id'].present?
      conditions << {
        'type' => 'inbox_matches',
        'value' => stage['inbox_id']
      }
    end

    # Avalia as condições (incluindo inbox_matches se configurado)
    evaluate_conditions(conversation, conditions)
  end

  def evaluate_conditions(conversation, conditions)
    return true if conditions.blank?

    contact = conversation.contact

    conditions.all? do |condition|
      evaluate_condition(conversation, contact, condition)
    end
  end

  def evaluate_condition(conversation, contact, condition)
    case condition['type']
    when 'contact_has_tag'
      contact_has_tag?(contact, condition['value'])
    when 'contact_has_custom_attribute'
      contact_has_custom_attribute?(contact, condition['attribute'], condition['operator'], condition['value'])
    when 'message_contains'
      message_contains?(conversation, condition['value'])
    when 'conversation_has_priority'
      conversation_has_priority?(conversation, condition['value'])
    when 'inbox_matches'
      inbox_matches?(conversation, condition['value'])
    else
      true # Condição desconhecida, não bloqueia
    end
  end

  def contact_has_tag?(contact, tag_name)
    contact.labels.any? { |label| label.name.downcase == tag_name.downcase }
  end

  def contact_has_custom_attribute?(contact, attribute, operator, value)
    contact_value = contact.custom_attributes&.dig(attribute)
    return false if contact_value.blank?

    case operator
    when 'equal_to'
      contact_value.to_s == value.to_s
    when 'contains'
      contact_value.to_s.downcase.include?(value.to_s.downcase)
    when 'not_equal_to'
      contact_value.to_s != value.to_s
    else
      true
    end
  end

  def message_contains?(conversation, text)
    return false if conversation.messages.incoming.empty?

    last_message = conversation.messages.incoming.last
    last_message.content.to_s.downcase.include?(text.to_s.downcase)
  end

  def conversation_has_priority?(conversation, priority)
    conversation.priority == priority
  end

  def inbox_matches?(conversation, inbox_id)
    conversation.inbox_id.to_s == inbox_id.to_s
  end

  def create_kanban_item(conversation, funnel, stage_id, stage)
    # A verificação de existência foi movida para o método `perform`, tornando esta verificação redundante.
    # O item será criado apenas se não existir nenhum item para esta conversa em qualquer funil.

    ::KanbanItem.create!(
      account_id: conversation.account.id,
      funnel_id: funnel.id,
      funnel_stage: stage_id,
      position: funnel.kanban_items.count + 1,
      item_details: build_item_details(conversation, stage_id),
      conversation_display_id: conversation.display_id
    )
  end

  def build_item_details(conversation, stage_id)
    {
      title: conversation.contact&.name || 'Sem nome',
      status: 'open',
      description: '',
      currency: { symbol: 'R$', code: 'BRL', locale: 'pt-BR' },
      priority: conversation.priority || 'none',
      agent_id: conversation.assignee_id,
      conversation_id: conversation.display_id,
      scheduling_type: '',
      offers: [],
      custom_attributes: conversation.custom_attributes || [],
      notes: [
        id: SecureRandom.uuid,
        text: "Esse item foi criado automaticamente pela etapa #{stage_id} baseado nas condições configuradas!",
        created_at: Time.current
      ]
    }
  end
end
