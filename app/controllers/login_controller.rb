class LoginController < ApplicationController
  
  protect_from_forgery with: :null_session, only: [:create] 

  #If the user has an active session we redirect to the chat rooms page
  def index
    redirect_on_active_session
  end

  #Look for the user based on the email, if the user is found and is authenticated
  #log the user in by setting their id in the session cookies and redirect to the
  #chat rooms page.
  #If the user is not authenticated or cannot be found we show an error message and
  #render the index view.
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

  #Clear the users session cookie and send a notice that the user was logged out
  def logout
    session[:current_user_id] = nil
    redirect_to login_index_path, notice: "Successfully logged out"
  end

  #Log the user in using google by fetching the data from the oauth callback. 
  #If the user already has an account we find it and log it in
  #If the user does not have an account we create one based on the google account
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
