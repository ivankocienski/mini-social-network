class Conversation < ApplicationRecord

  has_many :conversation_users
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_user_id

  def self.create_between(user_a, user_b)

    conv = nil

    transaction do
      raise ActiveRecord::RecordNotUnique, 'Can\'t converse with self' if user_a == user_b

      ConversationUser.validate_unique_conversation_between! user_a, user_b

      conv = user_a.created_conversations.create!
      conv.conversation_users.create! user: user_a
      conv.conversation_users.create! user: user_b

    end

    conv
  end


  def stop(user)
  end

  def send_message(user)
  end

  def other_user_id(not_this_user)
    ConversationUser.
      where( conversation_id: self.id).
      where( 'user_id != ?', not_this_user.id ).
      first.
      id
  end

end
