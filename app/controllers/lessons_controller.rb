class LessonsController < ApplicationController
  before_action :set_user
  before_action :set_course
  before_action :set_lesson, only: %i[show edit update destroy]

  def index
    @lessons = @course.lessons.order(:order, updated_at: :desc) # Fetch lessons for a specific course, ordered by their order attribute
  end

  def show
  end

  def new
    @lesson = @course.lessons.build # Initializes a new lesson associated with the course
  end

  def create
    @lesson = @course.lessons.build(lesson_params) # Builds a new lesson under the course
    if @lesson.save
      redirect_to edit_course_path(@course), notice: "Lesson was added successfully."
    else
      flash.now[:alert] = @lesson.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @lesson.update(lesson_params)
      redirect_to course_lessons_path(@course, @lesson), notice: "Lesson was successfully updated."
    else
      flash.now[:alert] = @lesson.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lesson.destroy
    redirect_to course_lessons_path(@course), notice: "Lesson was successfully deleted."
  end

  private

  def set_user
    @user = current_user
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_lesson
    @lesson = @course.lessons.find(params[:id])
  end

  def lesson_params
    params.require(:lesson).permit(:title, :order, :video, :contents)
  end
end
