require 'rails_helper'

RSpec.describe Conversation, type: :model do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) } 
  let(:conversation) { Conversation.create_between(user_a, user_b) }

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
    before do
      conversation
    end

    context 'when initiator (owner) of conversation' do

      it 'deletes object and relationships to users' do
        expect(user_a.conversations.count).to eq(1)
        expect(user_b.conversations.count).to eq(1)

        conversation.stop(user_a)

        expect(user_a.conversations.count).to eq(0)
        expect(user_b.conversations.count).to eq(0)
      end
    end

    context 'when participant (non owner) of conversation' do
      it 'deletes object and relationships to users' do
        expect(user_a.conversations.count).to eq(1)
        expect(user_b.conversations.count).to eq(1)

        conversation.stop(user_b)

        expect(user_a.conversations.count).to eq(1) # still exists for this user
        expect(user_b.conversations.count).to eq(0)
      end

      it 'changes conversation state to "closed"' do
        conversation.stop(user_b)
        expect(conversation.state_for(user_a)).to eq('closed')
      end
    end
  end

  context '#other_user_id' do
    it 'shows me the other users ID' do
      expect(conversation.other_user_id(user_a)).to eq(user_b.id)
      expect(conversation.other_user_id(user_b)).to eq(user_a.id)
    end
  end

  context '#is_owned_by' do
    it 'is true when called with owning user' do
      expect(conversation.is_owned_by?(user_a)).to be_truthy
      expect(conversation.is_owned_by?(user_b)).to be_falsey
    end
  end

  context '#state_for' do
    context 'when in new state' do
      context 'when owner calls' do
        it 'returns "new" state' do
          expect(conversation.state_for(user_a)).to eq('new')
        end
      end

      context 'when participant calls' do
        it 'returns "invite" state' do
          expect(conversation.state_for(user_b)).to eq('invite')
        end
      end
    end

    context 'when in open state' do
      before do
        conversation.update! state: 'open'
      end

      it 'returns "open" state' do
        expect(conversation.state_for(user_a)).to eq('open')
        expect(conversation.state_for(user_b)).to eq('open')
      end
    end
  end

  context '#reply_message' do
    context 'when initiating user' do
      context 'in "new" state' do
        it 'is blocked' do
          expect { conversation.reply_message(user_a, 'message') }.
            to raise_error(ActiveRecord::RecordInvalid)
        end

        it 'does not post reply' do
          expect {
            begin
              conversation.reply_message(user_a, 'message')
            rescue ActiveRecord::RecordInvalid
              # silence you
            end
          }.not_to change(Message, :count)
        end
      end

      context 'in "open" state' do
        before do
          conversation.update state: 'open'
        end

        it 'does not raise error' do
          expect { conversation.reply_message(user_a, 'message') }.
            not_to raise_error
        end

        it 'posts reply' do
          expect {
            conversation.reply_message(user_a, 'message')
          }.to change(Message, :count).by(1)
        end
      end

      context 'in "closed" state' do
        it 'raises error' do
          conversation.update state: 'closed'
          expect { conversation.reply_message(user_a, 'message') }.
            to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end

    context 'when participating user' do
      context 'when in "invite" state' do
        it 'changes to "open" state' do
          conversation.reply_message(user_b, 'message')
          expect(conversation.state_for(user_b)).to eq('open')
        end

        it 'posts reply' do
          expect {
            conversation.reply_message(user_b, 'message')
          }.to change(Message, :count).by(1)
        end
      end

      context 'when in "open" state' do
        it 'posts reply' do
          conversation.update state: 'open'
          expect {
            conversation.reply_message(user_b, 'message')
          }.to change(Message, :count).by(1)
        end
      end
    end

    context 'updated_at' do
      it 'is set to the time of the last reply' do
        conversation.update updated_at: Time.now - 100.days

        Timecop.freeze do
          conversation.reply_message(user_b, 'message')
          expect(conversation.updated_at).to eq(Time.now)
        end
      end
    end
  end

end
