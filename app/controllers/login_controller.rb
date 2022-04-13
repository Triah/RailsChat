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

  def google
    if request.env["omniauth.auth"]["info"]["email"].present?
      oauth_info = request.env["omniauth.auth"]
      user = User.find_by(email: oauth_info["info"]["email"])
      unless user.present?
        user = User.create({
          username: oauth_info["info"]["name"],
          email: oauth_info["info"]["email"],
          avatar_image_url: oauth_info["info"]["image"],
          password: SecureRandom.alphanumeric
        })
      end
      session[:current_user_id] = user.id
      redirect_to chat_rooms_path
    else
      flash[:error] = "There was an error trying to sign in with google"
      redirect_to login_index_path
    end
  end
end
