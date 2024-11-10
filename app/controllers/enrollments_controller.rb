class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[show edit update destroy]
  before_action :set_courses_and_students, only: %i[new create edit update]

  def index
    @enrollments = Enrollment.all
    flash.now[:notice] = t('enrollments.index.empty') if @enrollments.empty?
  end

  def show
  end

  def new
    @enrollment = Enrollment.new
  end

  def create
    @enrollment = Enrollment.new(enrollment_params)
    if @enrollment.save
      redirect_to @enrollment, notice: t('enrollments.create.success')
    else
      # flash.now[:alert] = @enrollment.errors.full_messages.join(", ")
      flash.now[:alert] = t('enrollments.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @enrollment.update(enrollment_params)
      redirect_to @enrollment, notice: t('enrollments.update.success')
    else
      # flash.now[:alert] = @enrollment.errors.full_messages.join(", ")
      flash.now[:alert] = t('enrollments.update.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @enrollment.destroy
      redirect_to enrollments_path, notice: t('enrollments.destroy.success')
    else
      redirect_to enrollments_path, alert: t('enrollments.destroy.failure')
    end
  end

  private

  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
  end

  def set_courses_and_students
    @courses = Course.all
    @students = User.all
  end

  def enrollment_params
    params.require(:enrollment).permit(:course_id, :student_id, :progress, :completion_status)
  end
end
