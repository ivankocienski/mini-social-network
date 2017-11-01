class V1::AuthController < V1::ApiController

  def login
    token = Auth::Authenticator.authorize_for_params(
      params[:email],
      params[:password])

    json_response({ auth_token: token })
  end

  def signup
  end

end
