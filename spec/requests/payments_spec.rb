require 'rails_helper'

RSpec.describe "Payments", type: :request do
  let(:user) { create(:user, :admin) }
  let(:course) { create(:course) }
  let(:payment) { create(:payment, user: user, course: course) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  def payments_path(course)
    course_payments_path(locale: I18n.locale, course_id: course.id)
  end

  def payment_path(course, payment)
    course_payment_path(locale: I18n.locale, course_id: course.id, id: payment.id)
  end

  describe "GET /courses/:course_id/payments" do
    it "returns http success" do
      get payments_path(course)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /courses/:course_id/payments/:id" do
    it "returns http success" do
      get payment_path(course, payment)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /courses/:course_id/payments/new" do
    it "returns http success" do
      get new_course_payment_path(locale: I18n.locale, course_id: course.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /courses/:course_id/payments/:id/edit" do
    it "returns http success" do
      get edit_course_payment_path(locale: I18n.locale, course_id: course.id, id: payment.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /courses/:course_id/payments" do
    it "creates a payment and an enrollment, then redirects to the course" do
      expect {
        post payments_path(course), params: { payment: { payment_type: "bkash", status: "paid" } }
      }.to change(Payment, :count).by(1).and change(Enrollment, :count).by(1)

      expect(response).to redirect_to(course_path(course))
    end
  end

  describe "DELETE /courses/:course_id/payments/:id" do
    it "deletes the payment and redirects to the payments index" do
      payment
      expect {
        delete payment_path(course, payment)
      }.to change(Payment, :count).by(-1)

      expect(response).to redirect_to(payments_path(course))
    end
  end
end
