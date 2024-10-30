class SessionsController < ApplicationController
  layout "application"

  def new
  end

  def create
  end

  def login
  end

  def attempt_login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if user.confirmed_at.nil?
        UserMailerJob.perform_async(user.id)
        redirect_to root_path
      else
        session[:user_id] = user.id
        session[:email] = user.email
        redirect_to root_path, notice: "Logged in successfully"
      end
    else
      flash.now[:alert] = "Invalid email or password"
      render :login, status: :unprocessable_entity
    end
  end

  def destroy
    params[:id] = nil
    session[:user_id] = nil
    session[:email] = nil
    redirect_to root_path, notice: "Logged out successfully"
  end

  def attempt_logout
    destroy
  end
end
