require 'rails_helper'

RSpec.describe V1::AuthController, type: :request do

  let(:user) { create :user }
  let(:headers) { valid_headers.except('Authorization') }

  context '/v1/login' do
    context 'when request is valid' do
      let(:valid_credentials) do
        { email: user.email, password: user.password }.to_json
      end

      before { post '/v1/login', params: valid_credentials, headers: headers }

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'when parameters are invalid' do
      let(:invalid_credentials) do
        { email: Faker::Internet.email, password: Faker::Internet.password }.to_json
      end

      before { post '/v1/login', params: invalid_credentials, headers: headers }

      it 'returns rejection HTTP status code' do
        expect(response).to have_http_status(401)
      end
    end
  end

  context '/v1/signup' do
    context 'with valid info' do
      let(:valid_credentials) do
        {
          name: user.name,
          email: user.email,
          password: user.password,
          password_confirmation: user.password
        }.to_json
      end

      before { post '/v1/login', params: valid_credentials, headers: headers }

      it 'returns an authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
    end

    context 'with invalid info' do
      let(:invalid_credentials) do
        {
          name: '',
          email: '%&^%$(*^&)',
          password: '',
          password_confirmation: 'not-a-real-cat'
        }.to_json
      end

      before { post '/v1/login', params: invalid_credentials, headers: headers }

      it 'sets status code to invalid' do
        expect(response).to have_http_status(401)
      end

      it 'has a message' do
        expect(json['message']).not_to be_nil
      end
    end
  end

end

