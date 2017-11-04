require 'rails_helper'

RSpec.describe V1::ConversationsController, type: :request do

  let!(:user) { create :user }

  context '#index' do
    before do
      Conversation.transaction do
        conversations = create_list(:conversation, 10, created_by: user)

        conversations.each do |c|
          ConversationUser.create! user: user, conversation: c
        end
      end
    end

    before do
      get '/v1/conversations', headers: valid_headers
    end

    it 'returns success' do
      expect(response).to have_http_status(200)
    end

    it 'has contents' do
      expect(json.length).to eq(10)
    end
  end

  context '#create' do

    let(:other_user) { create :user }

    context 'with valid params' do
      let(:params_json) { { other_user_id: other_user.id }.to_json }

      before do
        post '/v1/conversations', params: params_json, headers: valid_headers
      end

      it 'is created' do
        expect(response).to have_http_status(201)
      end

      it 'creates a conversation' do
        output = json
        expect(output['id']).not_to be_nil
        expect(output['other_user_id']).to eq(other_user.id)
      end
    end

    context 'with invalid commands' do

      context '(non existant user)' do
        let(:params_json) { { other_user_id: '1234' }.to_json }

        it 'is rejected' do
          post '/v1/conversations', params: params_json, headers: valid_headers

          expect(response).to have_http_status(404)
        end
      end

      context '(trying to talk to self)' do
        let(:params_json) { { other_user_id: user.id }.to_json }

        it 'is rejected' do
          post '/v1/conversations', params: params_json, headers: valid_headers

          expect(response).to have_http_status(422)
        end
      end

      context '(user already talking to)' do
        let(:params_json) { { other_user_id: other_user.id }.to_json }

        before do
          Conversation.create_between user, other_user
        end

        it 'is rejected' do
          post '/v1/conversations', params: params_json, headers: valid_headers

          expect(response).to have_http_status(422)
        end
      end
    end
  end

  context '#show' do
  end

  context '#update' do
  end

  context '#destroy' do
  end

end
