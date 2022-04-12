class ChatRoomsController < ApplicationController
  
  before_action :get_current_user_or_redirect

  def index
  end

  def show
    @current_chat_room = ChatRoom.find_by(id: params[:id])
    @messages = Message.where(chat_room_id: @current_chat_room.id)
  end

  def send_message

  end
end
