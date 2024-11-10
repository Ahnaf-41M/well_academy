class LessonsController < ApplicationController
  before_action :set_user
  before_action :set_course
  before_action :set_lesson, only: %i[show edit update destroy]
  # before_action :set_course_duration, only: %i[create edit update destroy]

  def index
    @lessons = @course.lessons.order(:order)
  end

  def show
  end

  def new
    @lesson = @course.lessons.build
  end

  def create
    @lesson = @course.lessons.build(lesson_params)
    if @lesson.save
      set_course_duration
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
      set_course_duration
      redirect_to course_lessons_path(@course, @lesson), notice: "Lesson was successfully updated."
    else
      flash.now[:alert] = @lesson.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lesson.destroy
    set_course_duration
    redirect_to course_lessons_path(@course), notice: "Lesson was successfully deleted."
  end

  def mark_as_watched
    @lesson = Lesson.find(params[:id])
    current_user.video_watches.create(lesson: @lesson, watched_at: Time.current) unless current_user.video_watches.exists?(lesson: @lesson)
    head :ok
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

  def set_course_duration
    @course.duration = 0
    @course.lessons.each do |lesson|
      if lesson.video.attached?
        video_path = ActiveStorage::Blob.service.path_for(lesson.video.key)
        movie = FFMPEG::Movie.new(video_path)
        @course.duration += movie.duration
      end
    end
    @course.save
  end

  def lesson_params
    params.require(:lesson).permit(:title, :order, :video, :content)
  end
end
