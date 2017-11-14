class ConversationSerializer < ActiveModel::Serializer
  attributes :id, :started_on, :state

  def joined
    object.created_at
  end

  def started_on
    object.created_at
  end

  def state
    object.state || 'new'
  end

  def self.serialize_for_show(conversation, current_user, messages)
    {
      id: conversation.id,
      state: conversation.state_for(current_user),
      other_user_id: conversation.other_user_id(current_user),
      started_on: conversation.created_at,
      last_message_on: conversation.updated_at,
      messages: messages.all
    }
  end

end
