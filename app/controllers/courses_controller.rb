class CoursesController < ApplicationController
  # load_and_authorize_resource

  before_action :set_user
  before_action :set_course, only: %i[show edit update destroy]
  before_action :set_categories, only: %i[create new show edit update destroy]
  before_action :update_enrollment, only: %i[show]

  def index_by_category
    category_id = params[:category_id]
    @category = Category.find(category_id)
    @courses = Course.where(category_id: category_id)
  end

  def index
    if @user.admin?
      @courses = Course.order(:title)
    else
      @courses = Course.where(teacher_id: @user.id).order(:title)
    end
  end

  def show
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    @course.duration = 0

    if @course.save
      redirect_to courses_path, notice: t('courses.create.success')
    else
      # flash.now[:alert] = @course.errors.full_messages.join(", ")
      flash.now[:alert] = t('courses.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @course.update(course_params)
      redirect_to courses_path, notice: t('courses.update.success')
    else
      # flash.now[:alert] = @course.errors.full_messages.join(", ")
      flash.now[:alert] = t('courses.update.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @course.destroy
      redirect_to courses_path, notice: t('courses.destroy.success')
    else
      # flash.now[:alert] = @course.errors.full_messages.join(", ")
      flash.now[:alert] = t('courses.destroy.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_course
    @course = Course.find(params[:id])
  end

  def set_categories
    @categories = Category.order(name: :asc)
  end

  def update_enrollment
    if @user
      @lesson_count = @course.lessons.count
      @lesson_completed = @user.video_watches.joins(:lesson).where(lessons: { course_id: @course.id }).count
      @progress = 0
      if @lesson_count > 0
        @progress = ((@lesson_completed / @lesson_count.to_f) * 100).round
      else
        @progress = 0
      end
    end
  end

  def course_params
    params.require(:course).permit(:title, :description, :teacher_id, :category_id, :price, :level, :language, :duration, :syllabus, :completion_certificate, :achievement_certificate, :display_picture)
  end
end
