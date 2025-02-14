class PasswordResetEmailJob
  include Sidekiq::Worker
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    user.generate_password_reset_token!
    UserMailer.password_reset(user).deliver_now if user.reset_password_token.present?
  end
end
