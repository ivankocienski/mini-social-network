class V1::SecureApiController < V1::ApiController

  before_action :authorize_request
  attr_reader :current_user

  private

  def authorize_request
    @current_user = Auth::UserResolver.resolve_for_request(request.headers)
  end

end

