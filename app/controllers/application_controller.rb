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

  def default_url_options
    { locale: I18n.locale }
  end

  rescue_from CanCan::AccessDenied do |exception|
    @error_message = exception.message

    redirect_to unauthorized_path, alert: exception.message
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

end
