class ReviewsController < ApplicationController
  load_and_authorize_resource
  before_action :set_user
  before_action :set_review, only: %i[show edit update destroy]
  before_action :set_course, only: %i[new create edit update destroy]

  def index
    @reviews = Review.all
    flash.now[:notice] = t('reviews.index.no_reviews') if @reviews.empty?
  end

  def show
  end

  def new
    @review = @course.reviews.build
  end

  def create
    @review = @course.reviews.build(review_params)
    @review.student_id = @user.id

    if @review.save
      redirect_to course_path(@course), notice: t('reviews.create.success')
    else
      # flash.now[:alert] = @review.errors.full_messages.join(", ")
      flash.now[:alert] = t('reviews.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to course_path(@review.course), notice: t('reviews.update.success')
    else
      # flash.now[:alert] = @review.errors.full_messages.join(", ")
      flash.now[:alert] = t('reviews.update.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review = @review.find_by(student_id: @user.id)
    if @review
      @review.destroy
      redirect_to course_path(@review.course), notice: t('reviews.destroy.success')
    else
      redirect_to course_path(@course), alert: t('reviews.destroy.failure')
    end
  end

  private

  def set_user
    @user = current_user
  end

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
