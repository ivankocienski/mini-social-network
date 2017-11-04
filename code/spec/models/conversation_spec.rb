require 'rails_helper'

RSpec.describe Conversation, type: :model do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }

  context 'self.create_between' do
    it 'is created' do
      conv = Conversation.create_between(user_a, user_b)
      expect(conv).not_to be_nil
    end

    it 'does not allow conversing with self' do
      expect { Conversation.create_between(user_a, user_a) }.
        to raise_error(ActiveRecord::RecordNotUnique, /can't converse with self/i)
    end
  end

  context '#stop' do
  end

  context '#send_message' do
  end

end
