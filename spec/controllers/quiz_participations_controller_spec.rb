require 'rails_helper'

RSpec.describe QuizParticipationsController, type: :controller do
  let(:quiz) { create(:quiz) }
  let(:student) { create(:user) }
  let(:admin) { create(:user, role: 'admin') }
  let(:valid_attributes) do
    {
      student_id: student.id,
      quiz_id: quiz.id,
      marks_obtained: 50,
      total_marks: 100,
      submitted_at: Time.now
    }
  end
  let(:invalid_attributes) do
    {
      student_id: student.id,
      quiz_id: quiz.id,
      marks_obtained: nil,
      total_marks: nil
    }
  end
  let(:quiz_participation) { create(:quiz_participation, quiz: quiz, student: student) }

  before do
    allow(controller).to receive(:current_user).and_return(admin)
  end

  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "sets flash notice when no quiz participations exist" do
      get :index
      expect(flash.now[:notice]).to eq(I18n.t('quiz_participations.index.no_participations'))
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      get :show, params: { id: quiz_participation.id }
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get :new, params: { quiz_id: quiz.id }
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "redirects to the quiz_participation show page" do
        post :create, params: { quiz_id: quiz.id, quiz_participation: valid_attributes }
        expect(response).to redirect_to(quiz_participation_path(assigns(:quiz_participation)))
        expect(flash[:notice]).to eq(I18n.t('quiz_participations.create.success'))
      end
    end

    context "with invalid attributes" do
      it "renders the new template" do
        post :create, params: { quiz_id: quiz.id, quiz_participation: invalid_attributes }
        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq(I18n.t('quiz_participations.create.failure'))
      end
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      get :edit, params: { id: quiz_participation.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "redirects to the quiz_participation show page" do
        patch :update, params: { id: quiz_participation.id, quiz_participation: valid_attributes }
        expect(response).to redirect_to(quiz_participation_path(quiz_participation))
        expect(flash[:notice]).to eq(I18n.t('quiz_participations.update.success'))
      end
    end

    context "with invalid attributes" do
      it "renders the edit template" do
        patch :update, params: { id: quiz_participation.id, quiz_participation: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(flash.now[:alert]).to eq(I18n.t('quiz_participations.update.failure'))
      end
    end
  end

  describe "DELETE #destroy" do
    it "redirects to the quiz participations index page" do
      quiz_participation = create(:quiz_participation, quiz: quiz, student: student)
      delete :destroy, params: { id: quiz_participation.id }
      expect(response).to redirect_to(quiz_participations_path)
      expect(flash[:notice]).to eq(I18n.t('quiz_participations.destroy.success'))
    end
  end
end
