class UserMailer < ApplicationMailer
  include Rails.application.routes.url_helpers
  default from: "no-reply@wellacademy.com"

  def welcome_email(user)
    @user = user
    @confirmation_url = confirmation_user_url(id: @user.id, token: @user.confirmation_token)
    mail(to: @user.email, subject: "Welcome to WellAcademy!")
  end

  def password_reset(user)
    @user = user
    @reset_link = edit_password_reset_url(reset_password_token: @user.reset_password_token)
    mail(to: @user.email, subject: "Password Reset Instructions")
  end
end
