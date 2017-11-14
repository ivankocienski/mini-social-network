class V1::ConversationsController < V1::SecureApiController

  include Pagination

  before_action :find_conversation, only: %i{ show update destroy }

  def index
    conversations = current_user.conversations.
      offset(offset_param).
      limit(limit_param).
      order(:created_at).
      all

    total_count = current_user.conversations.count

    payload = {
      offset: offset_param,
      limit: limit_param,
      total_count: total_count,
      conversations: serialize_resource(conversations)
    }

    json_response payload
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
    messages = @conversation.messages.
      order(:created_at). # chat order
      limit(limit_param)

    if params[:from_time]
      messages = messages.
        where('created_at >= ?', params[:from_time])
    end

    payload = ConversationSerializer.serialize_for_show(
      @conversation,
      current_user,
      messages
    )

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
    @conversation.stop current_user
    payload = {
      conversation: 'stopped'
    }
    json_response payload, :accepted
  end

  private

  def find_conversation
    @conversation = current_user.conversations.find params[:id]
  end
end

