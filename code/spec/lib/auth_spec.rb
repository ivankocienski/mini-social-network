require 'rails_helper'

RSpec.describe Auth do

  describe Auth::WebToken do 
    #subject { Auth::WebToken }

    let(:payload) { { data: 'magic123' } }

    context '#encode' do
      it 'encodes payloads' do
        expect(subject.encode(payload)).not_to be_nil
      end
    end

    context '#decode' do

      context 'with valid token' do
        let(:token) { subject.encode(payload) }
        it 'decodes payload' do
          expect(subject.decode(token)[:data]).to eq(payload[:data])
        end
      end

      context 'with invalid data' do
        let(:token) { 'not a token' }

        it 'decodes invalid payload' do
          expect { subject.decode(token) }
            .to raise_error(ExceptionHandler::InvalidToken)
        end
      end

      context 'with expired token' do
        let(:token) { subject.encode(payload, Time.now - 100.hours) }

        it 'decodes invalid payload' do
          expect { subject.decode(token) }
            .to raise_error(ExceptionHandler::ExpiredSignature)
        end
      end
    end
  end

  describe Auth::UserResolver do
    context '#header_token' do
      context 'with proper header' do
        let(:token) { 'abcd1234' }
        let(:headers) { { 'Authorization' => token } }

        it 'returns token' do
          expect(subject.header_token(headers)).to eq(token)
        end
      end

      context 'with missing header' do
        let(:bad_headers) { {} }

        it 'raises error' do
          expect { subject.header_token(bad_headers) }
            .to raise_error(ExceptionHandler::MissingToken)
        end
      end
    end

    context '#user_id_from' do
      context 'with proper headers' do
        let(:user_id) { '1234' }
        let(:payload) { { user_id: user_id } }
        let(:token) { Auth::WebToken.encode(payload) }
        let(:headers) { { 'Authorization' => token } }

        it 'returns user ID' do
          expect(subject.user_id_from(headers)).to eq(user_id)
        end
      end

      context 'with malformed headers' do
        let(:payload) { { } }
        let(:token) { Auth::WebToken.encode(payload) }
        let(:bad_headers) { { 'Authorization' => token } }

        it 'raises error' do
          expect { subject.user_id_from(bad_headers) }
            .to raise_error(ExceptionHandler::MissingToken)
        end
      end
    end

    context '#resolve_for_request' do
      context 'with proper headers' do
        let(:user) { create :user }

        let(:user_id) { user.id }
        let(:payload) { { user_id: user_id } }
        let(:token) { Auth::WebToken.encode(payload) }
        let(:headers) { { 'Authorization' => token } }

        it 'returns user ID' do
          expect(subject.resolve_for_request(headers)).to eq(user)
        end
      end

      context 'with improper headers' do
        let(:user_id) { '1234' }
        let(:payload) { { user_id: user_id } }
        let(:token) { Auth::WebToken.encode(payload) }
        let(:bad_headers) { { 'Authorization' => token } }

        it 'raises error' do
          expect { subject.resolve_for_request(bad_headers) }
            .to raise_error(ExceptionHandler::InvalidToken)
        end
      end
    end
  end
end
