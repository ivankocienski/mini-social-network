class V1::ConversationsController < V1::SecureApiController

  before_action :find_convesation, only: %i{ show update destroy }

  def index
    json_response current_user.conversations.all
  end

  def create
    found_user = User.find params[:other_user_id]
    convo = Conversation.create_between(current_user, found_user)

    payload = {
      id: convo.id,
      other_user_id: found_user.id
    }

    json_response payload, :created
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def find_conversation
    @conversation = current_user.conversations.find params[:id]
  end
end

