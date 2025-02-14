require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { build(:question) }

  describe "validations" do
    it 'is valid with valid attributes' do
      expect(question).to be_valid
    end

    it 'is not valid without content' do
      question.content = nil
      expect(question).not_to be_valid
    end

    it 'is not valid without marks' do
      question.marks = nil
      expect(question).not_to be_valid
    end

    it 'is not valid without a quiz' do
      question.quiz = nil
      expect(question).not_to be_valid
    end

    it 'has a valid factory' do
      expect(build(:question)).to be_valid
    end
  end
end
