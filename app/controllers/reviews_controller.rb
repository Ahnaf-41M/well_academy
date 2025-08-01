class ReviewsController < ApplicationController
  REVIEWS_PER_PAGE = 10

  load_and_authorize_resource

  before_action :set_review, only: %i[show edit update destroy]
  before_action :set_course, only: %i[new create edit update destroy]

  def index
    @reviews = Review.where(course_id: params[:course_id]).page(params[:page]).per(REVIEWS_PER_PAGE)
    @course = Course.find(params[:course_id])
    @teacher = @course.teacher
  end

  def show
  end

  def new
    @review = @course.reviews.build
  end

  def create
    @review = @course.reviews.build(review_params)
    @review.student_id = current_user.id

    if @review.save
      redirect_to course_path(@course), notice: t("reviews.create.success")
    else
      flash.now[:alert] = t("reviews.create.failure", error: @review.errors.full_messages.join(", "))
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to course_path(@review.course), notice: t("reviews.update.success")
    else
      flash.now[:alert] = t("reviews.update.failure", error: @review.errors.full_messages.join(", "))
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review = @course.reviews.find_by(id: params[:id], student_id: current_user.id)

    if @review
      @review.destroy
      redirect_to course_path(@review.course), notice: t("reviews.destroy.success")
    else
      redirect_to course_path(@course), alert: t("reviews.destroy.failure")
    end
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
