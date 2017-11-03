class V1::ConversationsController < V1::SecureApiController

  def index
    json_response current_user.conversations.all
  end

  def create
  end

  def show
  end

  def update
  end

  def destroy
  end

end

