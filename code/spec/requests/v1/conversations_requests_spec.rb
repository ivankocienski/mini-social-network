require 'rails_helper'

RSpec.describe V1::ConversationsController, type: :request do

  let!(:user) { create :user }
  let(:other_user) { create :user }
  let(:conversation) { Conversation.create_between user, other_user }

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
    before do
      conversation.messages.create! user: user, text: "reply 1"
      conversation.messages.create! user: user, text: "reply 2"
      conversation.messages.create! user: user, text: "reply 3"
      get "/v1/conversations/#{conversation.id}", headers: valid_headers
    end

    it 'shows the conversation' do
      expect(response).to have_http_status(200)
    end

    it 'has conversation data' do
      data = json
      expect(data['id']).to eq(conversation.id)
      expect(data['other_user_id']).to eq(other_user.id)
      expect(data['started']).not_to be_nil
      expect(data['messages'].length).to eq(3)
    end
  end

  context '#update' do
    # see also spec/code for model Conversation#reply_message
    #   for the grittier DB details

    let(:params) { { 'message' => 'This is a reply' }.to_json }

    context 'when initiating user' do
      context 'when conversation is in "new" state' do
        before do
          put "/v1/conversations/#{conversation.id}", params: params, headers: valid_headers
        end

        it 'rejects request' do
          expect(response).to have_http_status(422)
        end
      end

      context 'when conversation is in "open" state' do
        before do
          conversation.update state: 'open'
          put "/v1/conversations/#{conversation.id}", params: params, headers: valid_headers
        end

        it 'accepts request' do
          expect(response).to have_http_status(202)
        end
      end
    end

    context 'when participating user' do
      let(:other_valid_headers) do
        valid_headers.tap do |vh|
          vh['Authorization'] = token_generator(other_user.id)
        end
      end

      before do
        put "/v1/conversations/#{conversation.id}", params: params, headers: other_valid_headers
      end

      it 'accepts request' do
        expect(response).to have_http_status(202)
      end
    end
  end

  context '#destroy' do
    it 'destroys conversation for user' do
      delete "/v1/conversations/#{conversation.id}", headers: valid_headers
      expect(response).to have_http_status(202)
    end
  end

end
