require 'rails_helper'

RSpec.describe Lesson, type: :model do
  let(:lesson) { create(:lesson) }

  describe 'validations' do
    it 'is not valid without a title' do
      lesson.title = nil
      expect(lesson).not_to be_valid
    end

    it 'is not valid without an order' do
      lesson.order = nil
      expect(lesson).not_to be_valid
    end

    it 'is not valid without a course' do
      lesson.course = nil
      expect(lesson).not_to be_valid
    end
  end
end
