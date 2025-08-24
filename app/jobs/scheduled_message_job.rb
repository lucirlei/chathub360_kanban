class ScheduledMessageJob < ApplicationJob
  queue_as :scheduled_messages

  def perform(scheduled_message_id)
    scheduled_message = ScheduledMessage.find(scheduled_message_id)

    # Usar a conversa existente
    conversation = scheduled_message.conversation

    # Garantir que a conversa está aberta para receber a mensagem
    conversation.open! unless conversation.open?

    # Enviar mensagem na conversa existente
    Messages::MessageBuilder.new(
      scheduled_message.user,
      conversation,
      {
        content: scheduled_message.content,
        message_type: :outgoing, # Certificar-se que é uma mensagem de saída
        private: false # Certificar-se que não é uma nota privada
        # inbox_id é herdado da conversa, não precisa ser passado explicitamente aqui
        # a menos que o MessageBuilder exija especificamente.
      }
    ).perform

    scheduled_message.update(status: :sent)
  rescue StandardError => e
    scheduled_message.update(status: :failed)
    Rails.logger.error "Failed to send scheduled message #{scheduled_message_id}: #{e.message}"
  end

  # Esta lógica pode não ser mais necessária se a conversa já existe e tem um contact_inbox.
  # Comentando por enquanto. Se o MessageBuilder não lidar com isso, precisaremos reavaliar.
  # def find_or_create_contact_inbox(scheduled_message)
  #   contact = scheduled_message.conversation.contact
  #   inbox = Inbox.find(scheduled_message.inbox_id)
  #
  #   ContactInbox.find_or_create_by!(
  #     contact_id: contact.id,
  #     inbox_id: scheduled_message.inbox_id,
  #     source_id: generate_source_id(contact, inbox)
  #   )
  # end

  # def generate_source_id(contact, inbox)
  #   case inbox.channel_type
  #   when 'Channel::Whatsapp'
  #     contact.phone_number
  #   when 'Channel::Email'
  #     contact.email
  #   else
  #     SecureRandom.uuid
  #   end
  # end
end
