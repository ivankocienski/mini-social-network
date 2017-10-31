module Auth

  module WebToken
    HMAC_SECRET = Rails.application.secrets.secret_key_base

    extend self

    def encode(payload, exp=24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode payload, HMAC_SECRET
    end

    def decode(token)
      body = JWT.decode(token, HMAC_SECRET).first

      HashWithIndifferentAccess.new body

    rescue JWT::ExpiredSignature, JWT::VerificationError => e
      raise ExceptionHandler::ExpiredSignature, e.message

    rescue JWT::DecodeError
      raise ExceptionHandler::InvalidToken
    end
  end

  module UserResolver

    extend self

    def resolve_for_request(headers)
      User.find user_id_from(headers)

    rescue ActiveRecord::RecordNotFound => e
      message = "Invalid token: #{e.message}"
      raise ExceptionHandler::InvalidToken, message
    end

    def user_id_from(headers)
      auth_payload = WebToken.decode(header_token(headers))
      return auth_payload[:user_id] if auth_payload[:user_id].present?

      raise ExceptionHandler::MissingToken
    end

    def header_token(headers)
      return headers['Authorization'] if headers['Authorization'].present?

      raise ExceptionHandler::MissingToken
    end
  end

end

