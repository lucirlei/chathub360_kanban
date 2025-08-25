# == Schema Information
#
# Table name: kanban_items
#
#  id                      :bigint           not null, primary key
#  assigned_agents         :jsonb
#  checklist               :jsonb
#  custom_attributes       :jsonb
#  funnel_stage            :string           not null
#  item_details            :jsonb
#  position                :integer          not null
#  stage_entered_at        :datetime
#  timer_duration          :integer          default(0)
#  timer_started_at        :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  account_id              :bigint           not null
#  conversation_display_id :bigint
#  funnel_id               :bigint           not null
#
# Indexes
#
#  index_kanban_items_on_account_id                                 (account_id)
#  index_kanban_items_on_account_id_and_funnel_id_and_funnel_stage  (account_id,funnel_id,funnel_stage)
#  index_kanban_items_on_assigned_agents                            (assigned_agents) USING gin
#  index_kanban_items_on_checklist                                  (checklist) USING gin
#  index_kanban_items_on_conversation_display_id                    (conversation_display_id)
#  index_kanban_items_on_funnel_id                                  (funnel_id)
#  index_kanban_items_on_funnel_id_and_funnel_stage                 (funnel_id,funnel_stage)
#  index_kanban_items_on_item_details                               (item_details) USING gin
#
# Foreign Keys
#
#  fk_rails_...  (funnel_id => funnels.id)
#

class KanbanItem < ApplicationRecord
  include Events::Types
  include KanbanActivityHandler
  include KanbanTemplateMessageHandler

  belongs_to :account
  belongs_to :conversation, lambda { |kanban_item|
    where(account_id: kanban_item.account_id)
  }, foreign_key: :conversation_display_id, primary_key: :display_id, class_name: 'Conversation', optional: true
  belongs_to :funnel

  validates :account_id, presence: true
  validates :funnel_id, presence: true
  validates :funnel_stage, presence: true
  validates :position, presence: true
  validates :item_details, presence: true

  validate :validate_item_details_title
  validate :validate_assigned_agents

  scope :order_by_position, -> { order(position: :asc) }
  scope :for_account, ->(account_id) { where(account_id: account_id) }
  scope :for_funnel, lambda { |funnel_id|
    where(funnel_id: funnel_id) if funnel_id.present?
  }
  scope :in_stage, ->(stage) { where(funnel_stage: stage) }

  # Scope para buscar itens por agente
  scope :assigned_to_agent, lambda { |agent_id|
    Rails.logger.info "=== assigned_to_agent scope called for agent #{agent_id}"
    where(
      "EXISTS (
      SELECT 1
      FROM jsonb_array_elements(kanban_items.assigned_agents) AS agent
      WHERE (agent->>'id')::int = ?
    )",
      agent_id.to_i
    )
  }

  scope :latest_only, -> { order(created_at: :desc).limit(1) }
  before_save :update_stage_entered_at, if: :funnel_stage_changed?
  before_create :set_stage_entered_at
  after_commit :handle_activity_changes, on: [:create, :update]
  after_commit :handle_conversation_linked, on: [:create, :update]

  has_many_attached :note_attachments
  has_many_attached :attachments

  validate :validate_attachments

  # Métodos para gerenciar agentes atribuídos
  def assign_agent(agent_id, assigned_by = nil)
    return false unless agent_id.present?

    agent = User.find_by(id: agent_id)
    return false unless agent

    # Verificar se o agente já está atribuído
    return false if agent_assigned?(agent_id)

    # Adicionar o agente à lista
    current_agents = assigned_agents || []
    current_agents << {
      id: agent.id,
      name: agent.name,
      email: agent.email,
      avatar_url: agent.avatar_url,
      assigned_at: Time.current,
      assigned_by: assigned_by&.id || Current.user&.id
    }

    self.assigned_agents = current_agents
    save
  end

  def remove_agent(agent_id)
    return false unless agent_id.present?

    current_agents = assigned_agents || []
    filtered_agents = current_agents.reject { |agent| agent['id'] == agent_id.to_i }

    if filtered_agents.length == current_agents.length
      false
    else
      self.assigned_agents = filtered_agents
      save
    end
  end

  def agent_assigned?(agent_id)
    return false unless assigned_agents.present?

    assigned_agents.any? { |agent| agent['id'] == agent_id.to_i }
  end

  def primary_agent
    return nil unless assigned_agents.present? && assigned_agents.any?

    # Retorna o primeiro agente como principal
    agent_data = assigned_agents.first
    User.find_by(id: agent_data['id']) if agent_data
  end

  def assigned_agent_ids
    return [] unless assigned_agents.present?

    assigned_agents.map { |agent| agent['id'] }
  end

  def assigned_agents_data
    return [] unless assigned_agents.present?

    assigned_agents.map do |agent_data|
      {
        id: agent_data['id'],
        name: agent_data['name'],
        email: agent_data['email'],
        avatar_url: agent_data['avatar_url'],
        assigned_at: agent_data['assigned_at'],
        assigned_by: agent_data['assigned_by']
      }
    end
  end

  # Método de compatibilidade para manter funcionalidade existente
  def agent
    primary_agent
  end

  def move_to_stage(new_stage, stage_entered_at = nil)
    return if new_stage == funnel_stage

    update(
      funnel_stage: new_stage,
      stage_entered_at: stage_entered_at || Time.current
    )
  end

  def start_timer
    return if timer_started_at.present?

    update(timer_started_at: Time.current)
  end

  def stop_timer
    return unless timer_started_at.present?

    elapsed_time = Time.current - timer_started_at
    update(
      timer_started_at: nil,
      timer_duration: timer_duration + elapsed_time.to_i
    )
  end

  def time_in_current_stage
    return 0 unless stage_entered_at

    (Time.current - stage_entered_at).to_i
  end

  def self.debug_counts
    Rails.logger.info '=== KanbanItem Debug Counts ==='
    Rails.logger.info "Total items: #{count}"
    Rails.logger.info "Items by funnel: #{group(:funnel_id).count}"
    Rails.logger.info "Items by stage: #{group(:funnel_stage).count}"
  end

  def validate_note_attachment(attachment)
    return false unless attachment

    if attachment.blob.byte_size > 40.megabytes
      errors.add(:note_attachments, 'size must be less than 40MB')
      return false
    end

    content_type = attachment.blob.content_type
    unless content_type.in?(%w[image/png image/jpg image/jpeg application/pdf])
      errors.add(:note_attachments, 'must be an image (png, jpg) or PDF')
      return false
    end
    true
  end

  def serialized_attachments
    return [] unless attachments.attached?

    attachments.map do |attachment|
      {
        id: attachment.id,
        url: Rails.application.routes.url_helpers.rails_blob_url(attachment, only_path: true),
        filename: attachment.filename.to_s,
        byte_size: attachment.byte_size,
        content_type: attachment.content_type,
        created_at: attachment.created_at,
        source: {
          type: 'item',
          id: id
        }
      }
    end
  end

  # Retorna os dados serializados do funnel associado
  def funnel_data
    return unless funnel

    {
      id: funnel.id,
      name: funnel.name,
      description: funnel.description,
      active: funnel.active,
      stages: funnel.stages,
      settings: funnel.settings
    }
  end

  # Retorna os dados serializados da conversation associada, se houver
  def conversation_data
    conv = conversation
    return unless conv

    {
      id: conv.id,
      display_id: conv.display_id,
      inbox_id: conv.inbox_id,
      account_id: conv.account_id,
      status: conv.status,
      priority: conv.priority,
      team_id: conv.team_id,
      campaign_id: conv.campaign_id,
      snoozed_until: conv.snoozed_until,
      waiting_since: conv.waiting_since,
      first_reply_created_at: conv.first_reply_created_at,
      last_activity_at: conv.last_activity_at,
      additional_attributes: conv.additional_attributes,
      custom_attributes: conv.custom_attributes,
      uuid: conv.uuid,
      created_at: conv.created_at,
      updated_at: conv.updated_at,
      label_list: conv.try(:cached_label_list_array),
      unread_count: conv.try(:unread_messages)&.count,
      assignee: (if conv.assignee.present?
                   {
                     id: conv.assignee.id,
                     name: conv.assignee.name,
                     email: conv.assignee.email,
                     avatar_url: conv.assignee.avatar_url,
                     availability_status: conv.assignee.availability_status
                   }
                 end),
      contact: (if conv.contact.present?
                  {
                    id: conv.contact.id,
                    name: conv.contact.name,
                    email: conv.contact.email,
                    phone_number: conv.contact.phone_number,
                    thumbnail: conv.contact.avatar_url,
                    additional_attributes: conv.contact.additional_attributes
                  }
                end),
      messages_count: conv.try(:messages)&.count,
      inbox: (if conv.inbox.present?
                {
                  id: conv.inbox.id,
                  name: conv.inbox.name,
                  channel_type: conv.inbox.channel_type
                }
              end)
    }
  end

  def as_json(options = {})
    super(options).merge(
      'agent' => agent&.as_json(only: %i[id name email avatar_url availability_status]),
      'assigned_agents' => assigned_agents_data,
      'funnel' => funnel_data,
      'conversation' => conversation_data,
      'attachments' => serialized_attachments
    )
  end

  def validate_attachments
    return unless attachments.attached?

    attachments.each do |attachment|
      unless attachment.content_type.in?(%w[
                                           image/png image/jpg image/jpeg image/gif
                                           application/pdf
                                           application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document
                                           application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
                                         ])
        errors.add(:attachments, 'deve ser uma imagem (png, jpg, gif), PDF, DOC ou XLS')
      end

      errors.add(:attachments, 'deve ter menos de 10MB') if attachment.byte_size > 10.megabytes
    end
  end

  def validate_item_details_title
    if item_details.is_a?(Hash)
      errors.add(:item_details, 'deve conter o campo title preenchido') if item_details['title'].blank?
    else
      errors.add(:item_details, 'deve ser um objeto com o campo title')
    end
  end

  def validate_assigned_agents
    return unless assigned_agents.present?

    unless assigned_agents.is_a?(Array)
      errors.add(:assigned_agents, 'deve ser um array')
      return
    end

    assigned_agents.each_with_index do |agent_data, index|
      unless agent_data.is_a?(Hash)
        errors.add(:assigned_agents, "agente na posição #{index} deve ser um objeto")
        next
      end

      errors.add(:assigned_agents, "agente na posição #{index} deve ter um ID") unless agent_data['id'].present?
    end
  end

  private

  def handle_activity_changes
    handle_stage_change
    handle_priority_change
    handle_agent_change
    handle_value_change
    handle_template_message_on_stage_change
  end

  def set_stage_entered_at
    self.stage_entered_at = Time.current
  end

  def update_stage_entered_at
    self.stage_entered_at = Time.current
  end
end
