class CoursesController < ApplicationController
  COURSES_PER_PAGE = 6

  before_action :set_course, only: %i[show edit update destroy]
  before_action :set_categories, only: %i[create new show edit update destroy]
  before_action :update_enrollment, only: %i[show]

  load_and_authorize_resource :course, only: %i[new create edit update destroy]

  def index
    if current_user.admin?
      @courses = Course.includes(:teacher, :category)
                       .order(:title)
                       .page(params[:page])
                       .per(COURSES_PER_PAGE)
    else
      @courses = Course.where(teacher_id: current_user.id)
                       .order(:title)
                       .page(params[:page])
                       .per(COURSES_PER_PAGE)
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
      redirect_to courses_path, notice: t("courses.create.success")
    else
      flash.now[:alert] = t("courses.create.failure", errors: @course.errors.full_messages.join(","))
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @course.update(course_params.except(:teacher_id))
      redirect_to edit_course_path(@course), notice: t("courses.update.success")
    else
      flash.now[:alert] = t("course.update.failure", errors: @course.errors.full_messages.join(","))
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @course.destroy
      redirect_to courses_path, notice: t("courses.destroy.success")
    else
      flash.now[:alert] = t("courses.destroy.failure", errors: @course.errors.full_messages.join(","))
      render :edit, status: :unprocessable_entity
    end
  end

  def index_by_category
    category_id = params[:category_id]
    @category = Category.find(category_id)
    @courses = Course.where(category_id: category_id)
                     .includes(:teacher, :display_picture_attachment)
                     .page(params[:page]).per(COURSES_PER_PAGE)
  end

  def enrollments
    course_ids = current_user.enrollments.select(:course_id)
    @courses = Course.where(id: course_ids)
                     .includes(:teacher, :category)
                     .order(:title)
                     .page(params[:pager]).per(COURSES_PER_PAGE)
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def set_categories
    @categories = Category.order(name: :asc)
  end

  def update_enrollment
    if current_user
      @lesson_count = @course.lessons.count
      @lesson_completed = current_user.video_watches.joins(:lesson).where(lessons: { course_id: @course.id }).count
      @progress = 0
      if @lesson_count > 0
        @progress = ((@lesson_completed / @lesson_count.to_f) * 100).round
      else
        @progress = 0
      end
    end
  end

  def course_params
    params.require(:course)
          .permit(:title,
                  :description,
                  :teacher_id,
                  :category_id,
                  :price,
                  :level,
                  :language,
                  :duration,
                  :syllabus,
                  :completion_certificate,
                  :achievement_certificate,
                  :display_picture
                )
  end
end
