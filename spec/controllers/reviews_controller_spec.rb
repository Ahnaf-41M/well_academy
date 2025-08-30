require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:user) { create(:user) }
  let(:course) { create(:course) }
  let(:review) { create(:review, course: course, student: user) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    it "renders the index template" do
      get :index, params: { course_id: course.id }
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      get :show, params: { course_id: course.id, id: review.id }
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
    context "when the review is saved successfully" do
      it "redirects to the course path with a success notice" do
        post :create, params: { course_id: course.id, review: { rating: 4, comment: "Great course!" } }
        expect(response).to redirect_to(course_path(course))
        expect(flash[:notice]).to eq(I18n.t('reviews.create.success'))
      end
    end

    context "when the review fails to save" do
      it "renders the new template with an alert" do
        post :create, params: { course_id: course.id, review: { rating: nil } }
        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq(I18n.t('reviews.create.failure'))
      end
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      get :edit, params: { course_id: course.id, id: review.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    context "when the review updates successfully" do
      it "redirects to the course path with a success notice" do
        patch :update, params: { course_id: course.id, id: review.id, review: { rating: 3 } }
        expect(response).to redirect_to(course_path(course))
        expect(flash[:notice]).to eq(I18n.t('reviews.update.success'))
      end
    end

    context "when the review fails to update" do
      it "renders the edit template with an alert" do
        patch :update, params: { course_id: course.id, id: review.id, review: { rating: nil } }
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq(I18n.t('reviews.update.failure'))
      end
    end
  end

  describe "DELETE #destroy" do
    context "when the review is found and destroyed" do
      it "redirects to the course path with a success notice" do
        review_to_destroy = create(:review, course: course, student: user)
        delete :destroy, params: { course_id: course.id, id: review_to_destroy.id }
        expect(response).to redirect_to(course_path(course))
        expect(flash[:notice]).to eq(I18n.t('reviews.destroy.success'))
      end
    end
  end
end
