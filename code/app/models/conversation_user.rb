class ConversationUser < ApplicationRecord
  belongs_to :conversation
  belongs_to :user

  validates :conversation, uniqueness: { scope: :user }

  def self.validate_unique_conversation_between!(user_a, user_b)

    count = where(user_id: user_a.id).
      joins('JOIN conversation_users AS cu2 ON conversation_users.conversation_id = cu2.conversation_id').
      where('cu2.user_id': user_b.id).
      count

    raise ActiveRecord::RecordNotUnique if count > 0
  end

end
