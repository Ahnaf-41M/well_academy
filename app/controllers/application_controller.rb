class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :current_user, :logged_in?

  before_action :set_locale

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
