class Conversation < ApplicationRecord

  has_many :conversation_users
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_user_id

  def self.create_between(user_a, user_b)

    transaction do
      ConversationUser.validate_unique_conversation_between! user_a, user_b

      conv = user_a.created_conversations.create!
      conv.conversation_users.create! user: user_a
      conv.conversation_users.create! user: user_b

      conv
    end
  end


  def stop(user)
  end

  def send_message(user)
  end

end
