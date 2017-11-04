require 'rails_helper'

RSpec.describe V1::ConversationsController, type: :controller do

  let!(:user) { create :user }

  before do
    request.headers['Authorization'] = token_generator(user.id)
  end

  context '#find_conversation' do

    controller do
      before_action :find_conversation

      def show
        render json: { id: @conversation.id }
      end
    end

    context 'with valid conversation ID' do

      let(:other_user) { create :user }
      let(:conversation) { Conversation.create_between(user, other_user) }
      let(:params) { { id: conversation.id } }

      before do
        get :show, params: params
      end

      it 'allows request' do
        expect(response).to be_success
      end

      it 'invokes action with conversation set up' do
        expect(json['id']).to eq(conversation.id)
      end
    end

    context 'with invalid conversation ID' do
      let(:params) { { id: '1234' } }

      before do
        get :show, params: params
      end

      it 'rejects request' do
        expect(response).to have_http_status(404)
      end
    end
  end
end

