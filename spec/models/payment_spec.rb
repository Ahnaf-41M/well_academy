require 'rails_helper'

RSpec.describe Payment, type: :model do
  let(:payment) { build(:payment) }

  describe "validations" do
    it 'is valid with valid attributes' do
      expect(payment).to be_valid
    end

    it 'is not valid without a course price' do
      payment.course_price = nil
      expect(payment).not_to be_valid
    end

    it 'is not valid without a user' do
      payment.user = nil
      expect(payment).not_to be_valid
    end

    it 'is not valid without a course' do
      payment.course = nil
      expect(payment).not_to be_valid
    end
  end

  describe "enums" do
    it 'defines payment types' do
      expect(Payment.payment_types.keys).to include("bkash", "brac_bank")
    end

    it 'defines payment statuses' do
      expect(Payment.statuses.keys).to include("unpaid", "paid")
    end
  end
end
