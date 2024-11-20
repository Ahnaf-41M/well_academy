class ErrorsController < ApplicationController
  before_action :set_user

  def unauthorized
    @notice = params[:alert]
  end

  def set_user
    @user = current_user
  end
end
