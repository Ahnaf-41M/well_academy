class CoursesController < ApplicationController
  before_action :set_user, only: %i[index new show edit create update destroy]
  before_action :set_course, only: %i[show edit update destroy]
  before_action :set_categories, only: %i[new show edit update destroy]

  def index
    @courses = Course.order(:title)
  end

  def show
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new(course_params)
    hours = params[:course][:duration_hours].to_i
    minutes = params[:course][:duration_minutes].to_i
    @course.duration = (hours.hours + minutes.minutes)

    if @course.save
      redirect_to courses_path, notice: "Course was successfully created."
    else
      flash.now[:alert] = @course.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    hours = params[:course][:duration_hours].to_i
    minutes = params[:course][:duration_minutes].to_i
    @course.duration = (hours.hours + minutes.minutes)
    if @course.update(course_params)
      redirect_to courses_path, notice: "Course was successfully updated."
    else
      puts "** debug : #{@course.errors.full_messages.join(", ")}"
      flash.now[:alert] = @course.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @course.destroy
    redirect_to courses_path, notice: "Course was successfully destroyed."
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
  def course_params
    params.require(:course).permit(:title, :description, :teacher_id, :category_id, :price, :level, :language, :duration, :completion_certificate, :achievement_certificate)
  end
end
