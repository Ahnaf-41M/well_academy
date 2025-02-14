require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:review) { build(:review) }

  describe "validations" do
    it 'is valid with valid attributes' do
      expect(review).to be_valid
    end

    it 'is not valid without a course' do
      review.course = nil
      expect(review).not_to be_valid
    end

    it 'is not valid without a student' do
      review.student = nil
      expect(review).not_to be_valid
    end

    it 'is not valid without a rating' do
      review.rating = nil
      expect(review).not_to be_valid
    end

    it 'is not valid with a rating less than 1' do
      review.rating = 0
      expect(review).not_to be_valid
    end

    it 'is not valid with a rating greater than 5' do
      review.rating = 6
      expect(review).not_to be_valid
    end

    it 'has a valid factory' do
      expect(build(:review)).to be_valid
    end
  end
end
