require 'rails_helper'

RSpec.describe ConversationUser, type: :model do

  context 'self.validate_unique_conversation_between!' do

    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }

    it 'passes quietly when no relationship exists' do
      expect { ConversationUser.validate_unique_conversation_between!(user_a, user_b) }.
        not_to raise_error
    end

    it 'raises error when not unique' do

      conversation = user_a.created_conversations.create!
      ConversationUser.create! user_id: user_a.id, conversation_id: conversation.id
      ConversationUser.create! user_id: user_b.id, conversation_id: conversation.id


      expect { ConversationUser.validate_unique_conversation_between!(user_a, user_b) }.
        to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
