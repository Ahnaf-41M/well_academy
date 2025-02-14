require 'rails_helper'

RSpec.describe QuizParticipation, type: :model do
  let(:quiz_participation) { build(:quiz_participation) }

  describe "validations" do
    it 'is valid with valid attributes' do
      expect(quiz_participation).to be_valid
    end

    it 'is not valid without marks obtained' do
      quiz_participation.marks_obtained = nil
      expect(quiz_participation).not_to be_valid
    end

    it 'is not valid without total marks' do
      quiz_participation.total_marks = nil
      expect(quiz_participation).not_to be_valid
    end

    it 'is not valid without a student' do
      quiz_participation.student = nil
      expect(quiz_participation).not_to be_valid
    end

    it 'is not valid without a quiz' do
      quiz_participation.quiz = nil
      expect(quiz_participation).not_to be_valid
    end
  end
end
