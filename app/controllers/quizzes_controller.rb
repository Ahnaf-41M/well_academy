class QuizzesController < ApplicationController
  before_action :set_user
  before_action :set_course
  before_action :set_quiz, except: %i[dashboard index]
  before_action :set_question, only: %i[show submit]
  before_action :set_exam_quiz, only: %i[start]
  before_action :update_quiz_marks, only: %i[show create update destroy]

  def dashboard
  end

  def start
  end

  def submit
    @quiz_submission = params[:exam_quiz_questions]
    @marks = Hash.new
    @selected_answers = Hash.new
    @correct_answers = Hash.new
    @obtained_marks = 0

    @quiz_submission.each do |key, val|
      # puts "#{key}: #{val}"
      @selected_answers[val["id"]] = val["options"].values
                                                   .select { |option| option["is_correct"] == "1" }
                                                   .map { |option| option["option_text"] }
    end

    @questions.each do |question|
      @marks[question.id.to_s] = question.marks
      question.options.each do |hash|
        if hash["is_correct"] == "1"
          @correct_answers[question.id.to_s] ||= []
          @correct_answers[question.id.to_s] << hash["option_text"]
        end
      end
    end

    @selected_answers.each do |id, answers|
      if @correct_answers[id] == answers
        @obtained_marks += @marks[id].to_i
      end
    end

    puts "obtained #{@obtained_marks}"

    puts QuizParticipation.column_names

    @quiz_participation = QuizParticipation.new(
      student_id: @user.id,
      quiz_id: @quiz.id,
      marks_obtained: @obtained_marks,
      total_marks: @quiz.total_marks,
      submitted_at: Time.now
    )

    if @quiz_participation.save
      redirect_to course_path(@course)
    else
      flash.now[:alert] = @quiz_participation.errors.full_messages
      render :start, status: :unprocessable_entity
    end

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

  def set_exam_quiz
    @exam_quiz_questions = nil
    if @course.quiz.present?
      @exam_quiz_questions = @course.quiz.questions
      @exam_quiz_questions.each do |question|
        question.options.each do |option|
          option["is_correct"] = "0"
        end
      end

    end
  end

  def update_quiz_marks
    total_marks = 0
    @quiz.questions.each do |question|
      total_marks += question.marks
    end
    @quiz.total_marks = total_marks
  end

  def quiz_params
    params.require(:quiz).permit(:title, :total_marks)
  end
end
