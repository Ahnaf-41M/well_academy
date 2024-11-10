class PasswordResetsController < ApplicationController
  load_and_authorize_resource

  def new; end

  def create
    @user = User.find_by(email: params[:email])

    if @user
      @user.generate_password_reset_token!
      PasswordResetEmailJob.new.perform(@user.id) if @user.reset_password_token.present?
      flash[:notice] = t('password_resets.create.success')
      redirect_to root_path
    else
      flash.now[:alert] = t('password_resets.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find_by(reset_password_token: params[:id])

    if @user.nil? || @user.password_reset_token_expired?
      flash[:alert] = t('password_resets.edit.expired_link')
      redirect_to new_password_reset_path
    end
  end

  def update
    @user = User.find_by(reset_password_token: params[:id])

    if @user&.update(password_params)
      @user.update(reset_password_token: nil, reset_password_sent_at: nil)
      flash[:notice] = t('password_resets.update.success')
      redirect_to login_sessions_path
    else
      # flash.now[:alert] = @user.errors.full_messages.to_sentence
      flash.now[:alert] = t('password_resets.update.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
