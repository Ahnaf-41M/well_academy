class QuestionsController < ApplicationController
  before_action :set_user
  before_action :set_question, only: %i[show edit update destroy]
  before_action :set_quiz, except: %i[edit update destroy]
  before_action :set_course, except: %i[edit update destroy]

  def index
    @questions = @quiz.questions
    flash.now[:notice] = t('questions.index.no_questions') if @questions.empty?
  end

  def show
  end

  def new
    @question = @quiz.questions.new
    @question.options = []
  end

  def create
    @question = @quiz.questions.build(question_params)

    if question_params[:options].present?
      options_array = question_params[:options].to_h.values # Convert to array of option hashes
      @question.options = options_array.map do |option|
        {
          "option_text" => option["option_text"],
          "is_correct" => option["is_correct"] == "on" ? "1" : "0"
        }
      end
    end

    if @question.save
      redirect_to dashboard_course_quizzes_path(@course, @quiz), notice: t('questions.create.success')
    else
      # flash.now[:alert] = @question.errors.full_messages.join(", ")
      flash.now[:alert] = t('questions.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @course = @question.quiz.course
    @quiz = @question.quiz
  end

  def update
    if question_params[:options].present?
      options_array = question_params[:options].to_h.values # Convert to array of option hashes
      @question.options = options_array.map do |option|
        {
          "option_text" => option["option_text"],
          "is_correct" => option["is_correct"] == "on" || option["is_correct"]
        }
      end
    end

    if @question.update(question_params.except(:options))
      redirect_to course_quiz_path(@question.quiz.course, @question.quiz), notice: t('questions.update.success')
    else
      # flash.now[:alert] = @question.errors.full_messages.join(", ")
      flash.now[:alert] = t('questions.update.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @question.destroy
      redirect_to course_quiz_path(@question.quiz.course, @question.quiz), notice: t('questions.destroy.success')
    else
      # flash.now[:alert] = @question.errors.full_messages.join(", ")
      flash.now[:alert] = t('questions.destroy.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_course
    @course = @quiz.course
  end

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:content, :marks, options: [:option_text, :is_correct])
  end
end
