require 'rails_helper'

RSpec.describe Conversation, type: :model do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }

  context 'self.create_between' do
    it 'is created' do
      conv = Conversation.create_between(user_a, user_b)
      expect(conv).not_to be_nil
    end
  end

  context '#stop' do
  end

  context '#send_message' do
  end

end
