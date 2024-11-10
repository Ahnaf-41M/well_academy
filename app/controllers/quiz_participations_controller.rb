class QuizParticipationsController < ApplicationController
  load_and_authorize_resource
  before_action :set_quiz_participation, only: %i[show edit update destroy]
  before_action :set_quiz, only: %i[new create]

  def index
    @quiz_participations = QuizParticipation.all
    flash.now[:notice] = t('quiz_participations.index.no_participations') if @quiz_participations.empty?
  end

  def show
  end

  def new
    @quiz_participation = QuizParticipation.new
  end

  def create
    @quiz_participation = QuizParticipation.new(quiz_participation_params)

    if @quiz_participation.save
      redirect_to @quiz_participation, notice: t('quiz_participations.create.success')
    else
      # flash.now[:alert] = @quiz_participation.errors.full_messages.to_sentence
      flash.now[:alert] = t('quiz_participations.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @quiz_participation.update(quiz_participation_params)
      redirect_to @quiz_participation, notice: t('quiz_participations.update.success')
    else
      # flash.now[:alert] = @quiz_participation.errors.full_messages.to_sentence
      flash.now[:alert] = t('quiz_participations.update.failure')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @quiz_participation.destroy
      redirect_to quiz_participations_path, notice: t('quiz_participations.destroy.success')
    else
      # flash.now[:alert] = @quiz_participation.errors.full_messages.to_sentence
      flash.now[:alert] = t('quiz_participations.destroy.failure')
      redirect_to quiz_participation_path(@quiz_participation), status: :unprocessable_entity
    end
  end

  private

  def set_quiz_participation
    @quiz_participation = QuizParticipation.find(params[:id])
  end

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def quiz_participation_params
    params.require(:quiz_participation).permit(:student_id, :quiz_id, :marks_obtained, :total_marks, :submitted_at)
  end
end
