class QuestionsController < ApplicationController

  before_action :set_user
  before_action :set_question, only: %i[show edit update destroy]
  before_action :set_quiz, except: %i[show edit update destroy]
  before_action :set_course, except: %i[show edit update destroy]
  load_and_authorize_resource :course
  load_and_authorize_resource :quiz, through: :course
  load_and_authorize_resource :question, through: :quiz

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
    min_one_correct = false
    if question_params[:options].present?
      options_array = question_params[:options].to_h.values # Convert to array of option hashes
      @question.options = options_array.map do |option|
        {
          "option_text" => option["option_text"],
          "is_correct" => (option["is_correct"] == "on" || option["is_correct"] == "1") ? "1" : "0"
        }
      end

      options_array.each do |option|
        puts "#{option[:option_text]} => #{option[:is_correct]}"
        if option["is_correct"] == "on" || option["is_correct"] == "1"
          min_one_correct = true
        end
      end
    end

    if !min_one_correct
      flash.now[:alert] = t('questions.create.failure')
      render :new, status: :unprocessable_entity
    elsif @question.save
      redirect_to dashboard_course_quizzes_path(@course), notice: t('questions.create.success')
    else
      flash.now[:alert] = t('questions.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @course = @question.quiz.course # Ensure this gets the course from the associated quiz
    @quiz = @question.quiz
  end

  def update
    min_one_correct = false
    if question_params[:options].present?
      options_array = question_params[:options].to_h.values # Convert to array of option hashes
      @question.options = options_array.map do |option|
        {
          "option_text" => option["option_text"],
          "is_correct" => option["is_correct"] == "on" || option["is_correct"]
        }
      end

      options_array.each do |option|
        puts "#{option[:option_text]} => #{option[:is_correct]}"
        if option["is_correct"] == "on" || option["is_correct"] == "1"
          min_one_correct = true
        end
      end
    end

    if !min_one_correct
      flash.now[:alert] = t('questions.update.failure')
      render :edit, status: :unprocessable_entity
    elsif @question.update(question_params.except(:options))
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
      flash.now[:alert] = t('questions.destroy.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_course
    @course = @quiz.course # Ensure course is set from the quiz before actions
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
