class ApplicationController < ActionController::Base
  
  #Gets the current user from the session cookies
  #If no user is found it redirects to the login page
  def get_current_user_or_redirect
    @current_user = User.find_by(id: session[:current_user_id])
    redirect_to login_index_path unless @current_user.present?
  end

  #If the user is logged in and trying to access the login or register page
  #They are redirected to the chat rooms page
  def redirect_on_active_session
    @current_user = User.find_by(id: session[:current_user_id])
    if @current_user.present?
      redirect_to chat_rooms_path
    end
  end
end
