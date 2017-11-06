class Conversation < ApplicationRecord

  has_many :conversation_users, dependent: :destroy
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
    transaction do
      if is_owned_by?(user)
        destroy

      else # not owner
        update state: 'closed'
        conversation_users.where(user: user).destroy_all
      end
    end
  end

  def reply_message(user, message)

    transaction do
      if is_owned_by? user
        if state_for(user) == 'new'
          errors[:base] << 'Cannot reply to conversation that has not been accepted by other party'
          raise ActiveRecord::RecordInvalid, self
        end

        if state_for(user) == 'closed'
          errors[:base] << 'Cannot reply to conversation that has been closed'
          raise ActiveRecord::RecordInvalid, self
        end

      else # not owned by
        if state_for(user) == 'invite'
          update state: 'open'
        end
      end


      # do message things now...
    end
  end

  def is_owned_by?(user)
    self.created_by_user_id == user.id
  end

  def other_user_id(not_this_user)
    ConversationUser.
      where( conversation_id: self.id).
      where( 'user_id != ?', not_this_user.id ).
      first.
      id
  end

  def state_for(user)
    my_state = self.state || 'new'

    return 'invite' if my_state == 'new' && !is_owned_by?(user)

    my_state
  end

end
