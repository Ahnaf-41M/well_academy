class PasswordResetsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      @user.generate_password_reset_token!
      PasswordResetEmailJob.perform_async(@user.id) if @user.reset_password_token.present?
      flash[:notice] = t("password_resets.create.success")
      redirect_to root_path
    else
      flash.now[:alert] = t("password_resets.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find_by(reset_password_token: params[:reset_password_token])
    if @user.nil? || @user.password_reset_token_expired?
      flash[:alert] = t("password_resets.edit.expired_link")
      redirect_to new_password_reset_path
    end
  end

  def update
    @user = User.find_by(reset_password_token: params[:reset_password_token])
    if @user&.update(password_params)
      @user.update(reset_password_token: nil, reset_password_sent_at: nil)
      flash[:notice] = t("password_resets.update.success")
      redirect_to login_sessions_path
    else
      flash.now[:alert] = t("password_resets.update.failure", error: @user.errors.full_messages.join(","))
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
