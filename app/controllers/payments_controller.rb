class PaymentsController < ApplicationController
  before_action :set_course, only: %i[index new show edit create update destroy]
  before_action :set_payment, only: %i[show edit update destroy]
  before_action :set_user, only: %i[index new show edit create update destroy]

  def index
    @payments = Payment.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @payment = Payment.new(user_id: @user.id, course_id: @course.id)
  end

  def create
    # binding.pry
    @payment = Payment.new(payment_params)

    @payment.user_id = @user.id
    @payment.course_id = @course.id
    @payment.course_price = @course.price
    @payment.status = "paid"
    if @payment.save
      flash[:notice] = "Payment was done successfully."
      redirect_to course_path(@course)
    else
      flash.now[:alert] = @payment.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @payment.update(payment_params)
      flash[:notice] = "Payment updated successfully."
      redirect_to payment_path(@payment)
    else
      flash.now[:alert] = @payment.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @payment.destroy
      flash[:notice] = "Payment deleted successfully."
      redirect_to payments_path
    else
      flash.now[:alert] = @payment.errors.full_messages.to_sentence
      redirect_to payment_path(@payment), status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:user_id, :course_id, :course_price, :payment_type, :status)
  end

end
