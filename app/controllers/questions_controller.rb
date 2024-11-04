class QuestionsController < ApplicationController
  before_action :set_user
  before_action :set_course
  before_action :set_quiz
  before_action :set_question, only: %i[show edit update destroy]

  def index
    @questions = @quiz.questions
  end

  def show
  end

  def new
    @question = @quiz.questions.new
    @question.options = []
  end

  def create
    @question = @quiz.questions.build(question_params)
    
    @question.options = question_params[:options].map do |option|
      { "option_text" => option["option_text"], "is_correct" => option["is_correct"] == "on" }
    end

    if @question.save
      redirect_to dashboard_course_quizzes_path(@course, @quiz), notice: 'Question was successfully created.'
    else
      flash.now[:alert] = @question.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to dashboard_course_quizzes_path(@course, @quiz), notice: 'Question was successfully updated.'
    else
      flash.now[:alert] = @question.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @question.destroy
      redirect_to course_quiz_questions_path(@quiz.course, @quiz), notice: 'Question was successfully deleted.'
    else
      flash.now[:alert] = @question.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_question
    @question = @quiz.questions.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:content, :marks, options: [:option_text, :is_correct])
  end
end
