require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  let(:user) { create(:user, role: 'admin') }
  let(:course) { create(:course) }
  let(:payment) { create(:payment, user: user, course: course) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    it "assigns @payments and renders the index template" do
      get :index, params: { course_id: course.id }
      expect(assigns(:payments)).to eq([payment])  # Ensure @payments contains the expected payment
      expect(response).to render_template(:index)  # Ensure the correct template is rendered
    end
  end

  describe "GET #show" do
    it "assigns @payment and renders the show template" do
      get :show, params: { course_id: course.id, id: payment.id }
      expect(assigns(:payment)).to eq(payment)
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    it "assigns @payment and renders the new template" do
      get :new, params: { course_id: course.id }
      expect(assigns(:payment)).to be_a_new(Payment)
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new payment and redirects to course path" do
        expect {
          post :create, params: { course_id: course.id, payment: { user_id: user.id, course_price: course.price, payment_type: 'mobile', status: 'paid' } }
        }.to change(Payment, :count).by(1)

        expect(flash[:notice]).to eq('Payment was done successfully.')  # Check flash notice
        expect(response).to redirect_to(course_path(course))
      end
    end
  end

  describe "GET #edit" do
    it "assigns @payment and renders the edit template" do
      get :edit, params: { course_id: course.id, id: payment.id }
      expect(assigns(:payment)).to eq(payment)
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      it "updates the payment and redirects to show page" do
        put :update, params: { course_id: course.id, id: payment.id, payment: { payment_type: 'bank', status: 'paid' } }
        payment.reload
        expect(payment.payment_type).to eq('bank')
        expect(flash[:notice]).to eq('Payment updated successfully.')
        expect(response).to redirect_to(course_payment_path(payment))
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the payment and redirects to payments index" do
      payment # Create the payment object beforehand
      expect {
        delete :destroy, params: { course_id: course.id, id: payment.id }
      }.to change(Payment, :count).by(-1)

      expect(flash[:notice]).to eq('Payment deleted successfully.')
      expect(response).to redirect_to(course_payments_path)
    end
  end
end
