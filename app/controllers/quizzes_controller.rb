class QuizzesController < ApplicationController
  before_action :set_user
  before_action :set_course, only: %i[index new create show edit update destroy dashboard]
  before_action :set_quiz, only: %i[show edit update destroy]
  before_action :set_question, only: %i[show]

  def dashboard
  end

  def index
    @quizzes = @course.quiz
  end

  def show
  end

  def new
    @quiz = @course.build_quiz
  end

  def create
    @quiz = @course.build_quiz(quiz_params)
    @quiz.total_marks ||= 0
    if @quiz.save
      redirect_to dashboard_course_quizzes_path(@course), notice: 'Quiz was successfully created.'
    else
      flash.now[:alert] = @quiz.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    total_marks = 0
    @quiz.questions.each do |question|
      total_marks += question.marks
    end
    @quiz.total_marks = total_marks
    if @quiz.update(quiz_params)
      redirect_to course_quiz_path(@course), notice: 'Quiz was successfully updated.'
    else
      flash.now[:alert] = @quiz.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @quiz.destroy
    redirect_to dashboard_course_quizzes_path(@course), notice: 'Quiz was successfully deleted.'
  end

  private

  def set_user
    @user = current_user
  end

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_question
    @questions = @quiz.questions
  end

  def quiz_params
    params.require(:quiz).permit(:title, :total_marks)
  end
end
