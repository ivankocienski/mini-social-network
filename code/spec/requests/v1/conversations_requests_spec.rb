require 'rails_helper'

RSpec.describe V1::ConversationsController, type: :request do

  let!(:user) { create :user }
  let(:headers) { { 'Authorization' => token_generator(user.id) } }

  context '#index' do
    it 'returns success' do
      get '/v1/conversations', headers: headers
      expect(response).to have_http_status(200)
    end
  end

  context '#create' do
  end

  context '#show' do
  end

  context '#update' do
  end

  context '#destroy' do
  end

end
