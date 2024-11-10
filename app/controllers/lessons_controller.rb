class LessonsController < ApplicationController
  before_action :set_user
  before_action :set_course
  before_action :set_lesson, only: %i[show edit update destroy]

  def index
    @lessons = @course.lessons.order(:order)
    flash.now[:notice] = t('lessons.index.no_lessons') if @lessons.empty?
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
      redirect_to edit_course_path(@course), notice: t('lessons.create.success')
    else
      # flash.now[:alert] = @lesson.errors.full_messages.join(", ")
      flash.now[:alert] = t('lessons.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @lesson.update(lesson_params)
      set_course_duration
      redirect_to course_lessons_path(@course), notice: t('lessons.update.success')
    else
      # flash.now[:alert] = @lesson.errors.full_messages.join(", ")
      flash.now[:alert] = t('lessons.update.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lesson.destroy
    set_course_duration
    redirect_to course_lessons_path(@course), notice: t('lessons.destroy.success')
  end

  def mark_as_watched
    @lesson = Lesson.find(params[:id])
    if current_user.video_watches.exists?(lesson: @lesson)
      flash[:alert] = t('lessons.mark_as_watched.already_watched')
    else
      current_user.video_watches.create(lesson: @lesson, watched_at: Time.current)
      flash[:notice] = t('lessons.mark_as_watched.success')
    end
    redirect_to course_lessons_path(@course)
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
