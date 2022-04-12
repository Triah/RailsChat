class ApplicationController < ActionController::Base
  
  def get_current_user_or_redirect
    @current_user = User.find_by(id: session[:current_user_id])
    redirect_to login_index_path unless @current_user.present?
  end

  def redirect_on_active_session
    @current_user = User.find_by(id: session[:current_user_id])
    if @current_user.present?
      flash[:info] = "You are already logged in, please log out before attempting to log in again"
      redirect_to chat_rooms_path
    end
  end
end
