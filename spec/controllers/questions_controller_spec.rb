require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user, role: 'admin') }  # Replace with appropriate role if necessary
  let(:course) { create(:course) }
  let(:quiz) { create(:quiz, course: course) }
  let!(:question) { create(:question, quiz: quiz) }


  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    context "when there are questions for the quiz" do
      it "assigns @questions and renders the index template" do
        # get :index, params: { quiz_id: quiz.id }
        get :index, params: { course_id: course.id, quiz_id: quiz.id }


        expect(assigns(:questions)).to eq([ question ])
        expect(response).to render_template(:index)
      end
    end

    context "when there are no questions for the quiz" do
      it "assigns @questions as an empty array and renders the index template" do
        Question.delete_all  # Ensure no questions exist for the quiz
        get :index, params: { course_id: course.id, quiz_id: quiz.id }

        expect(assigns(:questions)).to eq([])
        expect(flash.now[:notice]).to eq(I18n.t('questions.index.no_questions'))
        expect(response).to render_template(:index)
      end
    end
  end

  describe "GET #show" do
    it "assigns @question and renders the show template" do
      get :show, params: { quiz_id: quiz.id, id: question.id }

      expect(assigns(:question)).to eq(question)
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    it "assigns a new question and renders the new template" do
      get :new, params: { course_id: course.id, quiz_id: quiz.id }

      expect(assigns(:question)).to be_a_new(Question)
      expect(response).to render_template(:new)
    end
  end

  describe "GET #edit" do
    it "assigns @question and renders the edit template" do
      get :edit, params: { quiz_id: quiz.id, id: question.id }

      expect(assigns(:question)).to eq(question)
      expect(response).to render_template(:edit)
    end
  end

  describe "DELETE #destroy" do
    it "deletes the question and redirects to the quiz show page" do
      expect {
        delete :destroy, params: { quiz_id: quiz.id, id: question.id }
      }.to change(Question, :count).by(-1)

      expect(response).to redirect_to(course_quiz_path(course, quiz))
      expect(flash[:notice]).to eq(I18n.t('questions.destroy.success'))
    end
  end
end
