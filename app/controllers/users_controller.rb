class UsersController < ApplicationController
  USERS_PER_PAGE = 6
  ENROLLMENTS_PER_PAGE = 2

  layout "application"

  load_and_authorize_resource

  def index
    @users = User.where.not(role: "admin")
                 .includes(:profile_picture_attachment)
                 .order(created_at: :desc)
                 .page(params[:page])
                 .per(USERS_PER_PAGE)
  end

  def show
    @enrollments = Enrollment.where(student_id: current_user.id)
                             .includes(:course)
                             .page(params[:page]).per(ENROLLMENTS_PER_PAGE)
  end

  def new
    redirect_to root_path if current_user.present?

    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailerJob.new.perform(@user.id)
      flash[:notice] = t("users.create.success")
      redirect_to root_path
    else
      # flash.now[:alert] = @user.errors.full_messages.to_sentence
      flash.now[:alert] = t("users.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @tmp_user = User.find(params[:id])
  end

  def update
    @tmp_user = User.find(params[:id])
    if @tmp_user.update(user_params)
      flash[:notice] = t("users.update.success")
      if @tmp_user == @user
        redirect_to user_path
      else
        redirect_to users_path
      end
    else
      flash.now[:alert] = t("users.update.failure")
      render :edit, status: :unprocessable_entity
    end
  end

  def delete
  end

  def destroy
    @tmp_user = User.find(params[:id])
    @tmp_user.courses.destroy_all if @tmp_user.courses
    @tmp_user.quiz_participations.destroy_all if @tmp_user.courses

    if @tmp_user.destroy
      flash[:notice] = t("users.destroy.success")
      redirect_to users_path
    else
      flash.now[:alert] = t("users.destroy.failure")
      render :show, status: :unprocessable_entity
    end
  end

  def confirm
    @user = User.find_by(confirmation_token: params[:token])
    if @user && @user.confirmed_at.nil?
      @user.update(confirmed_at: Time.now, confirmation_token: nil)
      redirect_to login_sessions_path, notice: t("users.confirm.success")
    else
      flash.now[:alert] = t("users.confirm.failure")
      redirect_to root_path, status: :unprocessable_entity
    end
  end

  def login
  end

  def become_teacher
  end

  def pending
    @pending_teachers = User.joins(:grad_certificate_attachment)
                            .where(role: "student")
                            .includes(
                              :profile_picture_attachment,
                              :grad_certificate_attachment,
                              :postgrad_certificate_attachment
                            )
                            .order(:name)
                            .page(params[:page])
                            .per(USERS_PER_PAGE)
  end

  def approve_teacher
    @tmp_user = User.find(params[:id])
    @tmp_user.role = :teacher

    if @tmp_user.save
      flash[:notice] = t("users.approve_teacher.success")
      redirect_to pending_users_path
    else
      flash.now[:alert] = t("users.approve_teacher.failure")
      render :pending, status: :unprocessable_entity
    end
  end

  def reject_teacher
    @tmp_user = User.find(params[:id])

    @tmp_user.grad_certificate.purge
    @tmp_user.postgrad_certificate.purge

    flash.now[:alert] = t("users.reject_teacher.success")
    render :pending, status: :unprocessable_entity
  end

  def remove_profile_picture
    @tmp_user = User.find(params[:id])
    @tmp_user.profile_picture&.destroy && @tmp_user.profile_picture.purge

    flash[:notice] = t("users.remove_profile_picture.success")
    redirect_to user_path
  end

  private

  def user_params
    params.require(:user).permit(:name,
                                 :email,
                                 :password,
                                 :password_confirmation,
                                 :phone,
                                 :date_joined,
                                 :bio,
                                 :role,
                                 :confirmation_token,
                                 :confirmed_at,
                                 :reset_password_token,
                                 :reset_password_sent_at,
                                 :profile_picture,
                                 :grad_certificate,
                                 :postgrad_certificate,
                                 student_certificates: [])
  end
end
