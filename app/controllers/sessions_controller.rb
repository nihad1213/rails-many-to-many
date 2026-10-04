class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].to_s.downcase)

    if user && user.authenticate(params[:session][:password])
      reset_session
      session[:user_id] = user.id
      flash[:notice] = "Logged in successfully."
      redirect_to articles_path
    else
      flash.now[:alert] = "Invalid email or password combination."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out."
    redirect_to root_path
  end
end
