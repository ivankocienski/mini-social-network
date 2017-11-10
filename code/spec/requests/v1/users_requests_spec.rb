require 'rails_helper'

RSpec.describe V1::ConversationsController, type: :request do

  let!(:user) { create :user }

  describe 'GET /v1/users' do
    it 'returns success code' do
      get '/v1/users', headers: valid_headers
      expect(response).to be_success
    end

    context 'with data' do
      before do
        create_list :user, 9
        get '/v1/users', headers: valid_headers
      end

      it 'shows a count of users' do
        expect(json['count']).to eq(10)
      end

      it 'has a list of users' do
        expect(json['users'].length).to eq(10)
      end
    end

    context 'pagination' do
      before do
        create_list :user, 199
        get '/v1/users', headers: valid_headers
      end

      it 'shows full count of users' do
        expect(json['count']).to eq(200)
      end

      it 'has limited returned values' do
        expect(json['users'].length).to eq(100)
      end
    end

    context 'name search' do
      before do
        3.times do |n|
          create :user, name: "alpha#{n}"
          create :user, name: "bob#{n}"
        end

        get '/v1/users', params: { search_name: 'alpha' }, headers: valid_headers
      end

      it 'can search for names' do
        expect(response).to be_success
        expect(json['users'].length).to eq(3)
      end
    end
  end

  describe 'GET /users/:id' do
    it 'shows user that exists' do
      get "/v1/users/#{user.id}", headers: valid_headers
      expect(response).to be_success
      expect(json['name']).to eq(user.name)
    end

    it 'responds in error when user does not exist' do
      get '/v1/users/1234abcd', headers: valid_headers
      expect(response).to have_http_status(404)
    end
  end
end
