require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:course) { create(:course) }

  describe 'validations' do
    it 'is not valid without a title' do
      course.title = nil
      expect(course).not_to be_valid
    end

    it 'is not valid without a description' do
      course.description = nil
      expect(course).not_to be_valid
    end

    it 'is not valid without a teacher' do
      course.teacher = nil
      expect(course).not_to be_valid
    end

    it 'is not valid without a category' do
      course.category = nil
      expect(course).not_to be_valid
    end

    it 'is not valid without a price' do
      course.price = nil
      expect(course).not_to be_valid
    end

    it 'is not valid without a language' do
      course.language = nil
      expect(course).not_to be_valid
    end

    it 'is not valid without a category' do
      course.category = nil
      expect(course).not_to be_valid
    end

    it 'is not valid without a duration' do
      course.duration = nil
      expect(course).not_to be_valid
    end
  end
end
