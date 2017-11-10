class V1::UsersController < V1::SecureApiController

  include Pagination

  def index
    if params[:search_name]
      user_count = User.search(params[:search_name]).count
      users = User.
        search(params[:search_name]).
        offset(offset_param).
        limit(limit_param).
        order(:name).
        all

    else
      user_count = User.count
      users = User.
        offset(offset_param).
        limit(limit_param).
        order(:name).
        all
    end


    payload = {
      count: user_count,
      offset: offset_param,
      limit: limit_param,
      users: users
    }

    json_response payload
  end

  def show
    user = User.find params[:id]
    payload = {
      id: user.id,
      joined_at: user.created_at,
      name: user.name
    }

    json_response payload
  end

end
