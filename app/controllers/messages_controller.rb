class MessagesController < ApplicationController
  def index
    session[:conversations] ||= []
    @users = User.all.where("id != ?", current_user.id)
    @conversations = Conversation.includes(:recipient, :messages)
      .find(session[:conversations])
  end

  def create
    @conversation = Conversation.includes(:recipient)
      .find params[:conversation_id]
    @message = @conversation.messages.build message_params

    respond_to do |format|
      format.js
    end
  end

  private

  def message_params
    params.require(:message).permit :user_id, :body
  end
end
