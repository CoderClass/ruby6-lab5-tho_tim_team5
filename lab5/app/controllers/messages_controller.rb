class MessagesController < ApplicationController

  def index
    @messages = Message.all.order(created_at: :DESC)
    @message = Message.new
  end

  def create
    @message = Message.new message_params


    if @message.save
      flash[:success] = "Message Sent"
      ActionCable.server.broadcast('chat', message: render_message(@message))
      redirect_to messages_path
    else
      flash[:error] = "Message Failure"
      redirect_to messages_path
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end

  def render_message(message)
    ApplicationController.render(partial: 'messages/message', locals: {message: message})
  end
end
