require 'rails_helper'

RSpec.describe QuizzesController, type: :controller do
  let(:course) { create(:course) }
  let(:quiz) { create(:quiz, course: course) }
  let(:user) { create(:user, role: 'admin') }
  let(:valid_attributes) { { title: "New Quiz", total_marks: 100 } }
  let(:invalid_attributes) { { title: "", total_marks: nil } }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    it "renders the index template" do
      get :index, params: { course_id: course.id }
      expect(response).to render_template(:index)
    end

    it "sets a flash notice when no quizzes exist" do
      get :index, params: { course_id: course.id }
      expect(flash.now[:notice]).to eq(I18n.t('quizzes.index.no_quizzes'))
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      get :show, params: { id: quiz.id, course_id: course.id }
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get :new, params: { course_id: course.id }
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "redirects to the dashboard" do
        post :create, params: { course_id: course.id, quiz: valid_attributes }
        expect(response).to redirect_to(dashboard_course_quizzes_path(course))
        expect(flash[:notice]).to eq(I18n.t('quizzes.create.success'))
      end
    end

    context "with invalid attributes" do
      it "renders the new template" do
        post :create, params: { course_id: course.id, quiz: invalid_attributes }
        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq(I18n.t('quizzes.create.failure'))
      end
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      get :edit, params: { id: quiz.id, course_id: course.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "redirects to the quiz show page" do
        patch :update, params: { id: quiz.id, course_id: course.id, quiz: valid_attributes }
        expect(response).to redirect_to(course_quiz_path(course, quiz))
        expect(flash[:notice]).to eq(I18n.t('quizzes.update.success'))
      end
    end

    context "with invalid attributes" do
      it "renders the edit template" do
        patch :update, params: { id: quiz.id, course_id: course.id, quiz: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(flash.now[:alert]).to eq(I18n.t('quizzes.create.failure'))
      end
    end
  end

  describe "DELETE #destroy" do
    it "redirects to the dashboard with a success message" do
      delete :destroy, params: { id: quiz.id, course_id: course.id }
      expect(response).to redirect_to(dashboard_course_quizzes_path(course))
      expect(flash[:notice]).to eq(I18n.t('quizzes.destroy.success'))
    end

    it "redirects to the quiz show page with an error message when destroy fails" do
      allow_any_instance_of(Quiz).to receive(:destroy).and_return(false)
      delete :destroy, params: { id: quiz.id, course_id: course.id }
      expect(response).to render_template(:show)
      expect(flash.now[:alert]).to eq(I18n.t('quizzes.destroy.failure'))
    end
  end

  describe "GET #start" do
    it "renders the start template" do
      get :start, params: { id: quiz.id, course_id: course.id }
      expect(response).to render_template(:start)
    end
  end
end
