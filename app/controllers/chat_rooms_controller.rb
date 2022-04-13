class ChatRoomsController < ApplicationController
  
  before_action :get_current_user_or_redirect

  def index
    @chat_rooms = []
    ChatRoom.order('last_message_at DESC').each do |chat_room|
      @chat_rooms << chat_room
    end
  end

  def show
    @current_chat_room = ChatRoom.find_by(id: params[:id])
    @messages = Message.limit(50).order('created_at DESC').where(chat_room_id: @current_chat_room.id).reverse
  end

  def send_message
    begin
      unless params[:content].blank?
        message = Message.new({
            content: params[:content], 
            chat_room_id: params[:chat_room_id],
            user_id: @current_user.id
          })
        if message.save
          ChatRoom.find_by(id: params[:chat_room_id]).update_columns(last_message_at: message.created_at)

          ActionCable.server.broadcast "chat_channel_#{params[:chat_room_id]}", {
            content: params[:content],
            author_id: @current_user.id,
            author_name: @current_user.username,
            avatar_url: @current_user.avatar_image_url.present? ? @current_user.avatar_image_url : ENV["DEFAULT_AVATAR_URL"],
            created_at: message.created_at
          }
        end
      end
    rescue => e
      #catch error in case of bad session or something similar preventing message from being saved
      puts e
    end 
  end
end
