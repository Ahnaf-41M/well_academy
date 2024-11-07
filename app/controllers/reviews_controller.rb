class ReviewsController < ApplicationController
  before_action :set_user
  before_action :set_review, only: %i[show edit update destroy]
  before_action :set_course, only: %i[new create edit update destroy]

  def index
    @reviews = Review.all
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
      redirect_to course_path(@course), notice: 'Review was successfully created.'
    else
      flash.now[:alert] = @review.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to course_path(@review.course), notice: 'Review was successfully updated.'
    else
      flash.now[:alert] = @review.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    redirect_to course_path(@review.course), notice: 'Review was successfully deleted.'
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
