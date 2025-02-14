class ErrorsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user

  def unauthorized
    @notice = params[:alert]
  end

  def not_found
    respond_to do |format|
      format.html { render status: 404 }
      format.json { render json: { error: "Not found" }, status: 404 }
    end
  end

  def internal_server_error
    respond_to do |format|
      format.html { render status: 500 }
      format.json { render json: { error: "Internal server error" }, status: 500 }
    end
  end

  def unprocessable_entity
    respond_to do |format|
      format.html { render status: 422 }
      format.json { render json: { error: "Unprocessable entity" }, status: 422 }
    end
  end

  def set_user
    @user = current_user
  end
end
