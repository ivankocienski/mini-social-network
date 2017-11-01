class V1::AuthController < V1::ApiController

  def login
    token = Auth::Authenticator.authorize_for_params(
      params[:email],
      params[:password])

    json_response({ auth_token: token })
  end

  def signup
    user = User.create!(user_params)
    auth_token = Auth::Authenticator.authorize_for_params(user.email, user.password)
    response = { message: 'User created', auth_token: auth_token }
    json_response response, :created
  end

  private

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
