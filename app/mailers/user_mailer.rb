class UserMailer < ApplicationMailer
  include Rails.application.routes.url_helpers
  default from: 'no-reply@wellacademy.com'

  def welcome_email(user)
    @user = user
    # @confirmation_url = confirmation_url(token: @user.confirmation_token)
    # @confirmation_url = url_for(controller: 'users', action: 'confirm', token: @user.confirmation_token, only_path: false)
    @confirmation_url = confirmation_user_url(@user, token: @user.confirmation_token)

    mail(to: @user.email, subject: 'Welcome to Our App!')
  end
end
