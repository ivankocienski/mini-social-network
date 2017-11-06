class V1::ConversationsController < V1::SecureApiController

  before_action :find_conversation, only: %i{ show update destroy }

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
    payload = {
      id: @conversation.id,
      state: @conversation.state_for(current_user),
      other_user_id: @conversation.other_user_id(current_user),
      started: @conversation.created_at,
      messages: [] # TODO
    }

    json_response payload
  end

  def update
    @conversation.reply_message current_user, params[:message]
    payload = {
      message: params[:message]
    }
    json_response payload, :accepted
  end

  def destroy
  end

  private

  def find_conversation
    @conversation = current_user.conversations.find params[:id]
  end
end

