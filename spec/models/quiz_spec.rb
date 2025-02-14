require 'rails_helper'

RSpec.describe Quiz, type: :model do
  let(:quiz) { build(:quiz) }

  describe "validations" do
    it 'is valid with valid attributes' do
      expect(quiz).to be_valid
    end

    it 'is not valid without a title' do
      quiz.title = nil
      expect(quiz).not_to be_valid
    end

    it 'is not valid without total marks' do
      quiz.total_marks = nil
      expect(quiz).not_to be_valid
    end

    it 'is not valid without a course' do
      quiz.course = nil
      expect(quiz).not_to be_valid
    end
  end
end
