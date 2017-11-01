
module ExceptionHandler

  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end
  class ExpiredSignature < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :four_oh_four
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from AuthenticationError, with: :unauthorized_request
    rescue_from MissingToken, with: :four_twenty_two
    rescue_from InvalidToken, with: :four_twenty_two
    rescue_from ExpiredSignature, with: :four_twenty_two
  end

  def four_oh_four(e)
    json_response({ message: e.message }, :not_found)
  end

  def four_twenty_two(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end

  def unauthorized_request(e)
    json_response({ message: e.message }, :unauthorized)
  end
end

