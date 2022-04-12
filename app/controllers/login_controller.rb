class LoginController < ApplicationController
  
  protect_from_forgery with: :null_session, only: [:create] 

  def index
    redirect_on_active_session
  end

  def login
    user = User.find_by(email: params[:email])

    if user.present? && user.authenticate(params[:password])
      session[:current_user_id] = user.id
      redirect_to chat_rooms_path
    else 
      flash[:error] = "Username or password incorrect"
      render :index
    end
  end

  def logout
    session[:current_user_id] = nil
    redirect_to login_index_path, notice: "Successfully logged out"
  end

  #create action for logging in with facebook and google
end
