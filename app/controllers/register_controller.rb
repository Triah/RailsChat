class RegisterController < ApplicationController

  #create a new user object to use as the model in the view
  def new
    redirect_on_active_session
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "Successfully created account"
      redirect_to login_index_path
    else
      render :new
    end
  end

  private 

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end