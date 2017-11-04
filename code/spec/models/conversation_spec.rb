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

  context '#other_user_id' do
    let(:conversation) { Conversation.create_between(user_a, user_b) }

    it 'shows me the other users ID' do
      expect(conversation.other_user_id(user_a)).to eq(user_b.id)
      expect(conversation.other_user_id(user_b)).to eq(user_a.id)
    end
  end

end
