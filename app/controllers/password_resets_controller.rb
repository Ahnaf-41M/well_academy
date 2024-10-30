class PasswordResetsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])

    if user
      user.generate_password_reset_token!
      # PasswordResetEmailJob.perform_async(user.id)
      UserMailer.password_reset(user).deliver_now if user.reset_password_token.present?
      flash[:notice] = "Password reset instructions have been sent to your email."
      redirect_to root_path
    else
      flash[:alert] = "Email not found."
      render :new
    end
  end

  def edit
    @user = User.find_by(reset_password_token: params[:id])

    if @user.nil? || @user.password_reset_token_expired?
      flash[:alert] = "Password reset link has expired. Please request a new one."
      redirect_to new_password_reset_path
    end
  end

  def update
    @user = User.find_by(reset_password_token: params[:id])

    if @user&.update(password_params)
      @user.update(reset_password_token: nil, reset_password_sent_at: nil) # Clear token
      flash[:notice] = "Password has been reset successfully."
      redirect_to login_sessions_path
    else
      flash.now[:alert] = "There was an error resetting your password."
      render :edit
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
