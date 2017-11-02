require 'rails_helper'

RSpec.describe V1::SecureApiController, type: :controller do

  let!(:user) { create :user }

  controller do
    def index
      render plain: 'content'
    end
  end

  context 'with valid credentials' do
    before do
      request.headers['Authorization'] = token_generator(user.id)
      get :index
    end

    it 'allows request' do
      expect(response).to be_success
    end
  end

  context 'with invalid credentials' do
    before do
      get :index
    end

    it 'rejects request' do
      expect(response).to have_http_status(422)
    end
  end

end

