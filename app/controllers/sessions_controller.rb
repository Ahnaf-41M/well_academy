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
      if user.confirmed_at.nil? && !user.confirmation_token.nil?
        UserMailerJob.new.perform(user.id)
        redirect_to root_path, notice: t('sessions.errors.unconfirmed_account')
      else
        session[:user_id] = user.id
        session[:email] = user.email
        redirect_to root_path, notice: t('sessions.create.success')
      end
    else
      flash.now[:alert] = t('sessions.errors.invalid_credentials')
      render :login, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    session[:email] = nil
    redirect_to root_path, notice: t('sessions.logout.success')
  end

  def attempt_logout
    destroy
  end
end
