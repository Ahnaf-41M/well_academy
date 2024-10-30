class UsersController < ApplicationController
  layout "application"

  load_and_authorize_resource

  before_action :set_user, only: %i[index show edit update destroy become_teacher pending]
  before_action :set_pending_users, only: %i[pending]
  after_action :set_pending_users, only: %i[reject_teacher]

  def index
    @users = User.where.not(role: "admin").order(:name)
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailerJob.perform_async(@user.id)
      flash[:notice] = "User created successfully."
      redirect_to root_path
    else
      # flash.now[:alert] = "Email already exists!"
      flash.now[:alert] = @user.errors.full_messages.to_sentence

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @tmp_user = User.find(params[:id])
  end

  def update
    @tmp_user = User.find(params[:id])
    if @tmp_user.update(user_params)
      flash[:notice] = "User updated successfully."
      if @tmp_user == @user
        redirect_to user_path
      else
        redirect_to users_path
      end
    else
      flash.now[:alert] = "Empty/Invalid fields!"
      render :edit, status: :unprocessable_entity
    end
  end

  def delete
  end

  def destroy
    @tmp_user = User.find(params[:id])
    @tmp_user.destroy
    flash[:notice] = "User deleted successfully."
    redirect_to users_path
  end

  def confirm
    # print "## token: #{params[:token]}"
    @user = User.find_by(confirmation_token: params[:token])
    if @user && @user.confirmed_at.nil?
      @user.update(confirmed_at: Time.now, confirmation_token: nil)
      redirect_to root_path, notice: "Your email has been confirmed successfully!"
    else
      flash.now[:alert] = "Invalid confirmation token or email already confirmed."
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  def login
  end

  def become_teacher
  end

  def pending
  end

  def approve_teacher
    @tmp_user = User.find(params[:id])

    @tmp_user.role = :teacher
    if @tmp_user.save
      flash[:notice] = "Teacher approved"
      redirect_to pending_users_path
    else
      flash.now[:alert] = "Couldn't approve teacher"
      render :pending, status: :unprocessable_entity
    end
  end

  def reject_teacher
    @tmp_user = User.find(params[:id])

    @tmp_user.grad_certificate.purge
    @tmp_user.postgrad_certificate.purge

    flash.now[:alert] = "User rejected successfully!"
    render :pending, status: :unprocessable_entity
  end

  def remove_profile_picture
    @tmp_user = User.find(params[:id])
    @tmp_user.profile_picture.purge

    flash.now[:alert] = "Profile picture removed successfully!"
    render :show, status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone, :date_joined, :bio, :role, :profile_picture, :grad_certificate, :postgrad_certificate, student_certificates: [])
  end

  def set_user
    @user = User.find(params[:id])
    @tmp_user = @user
  end

  def set_pending_users
    @users = User.all.select { |user| user.grad_certificate.attached? && user.student? }
  end
end
