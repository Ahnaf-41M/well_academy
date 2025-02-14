require "rails_helper"

RSpec.describe Enrollment, type: :model do
  let(:enrollment) { create(:enrollment) }

  # Validations
  describe 'validations' do
    it 'is not valid without a student' do
      enrollment.student = nil
      expect(enrollment).not_to be_valid
    end

    it 'is not valid without a course' do
      enrollment.course = nil
      expect(enrollment).not_to be_valid
    end

    it 'is not valid without an enrolled_at timestamp' do
      enrollment.enrolled_at = nil
      expect(enrollment).not_to be_valid
    end

    it 'is valid with progress defaulting to 0.0' do
      expect(enrollment.progress).to eq(0.0)
    end

    it 'is not valid with progress less than 0.0 or greater than 1.0' do
      enrollment.progress = -0.1
      expect(enrollment).not_to be_valid

      enrollment.progress = 1.1
      expect(enrollment).not_to be_valid
    end

    it 'is not valid with an invalid completion_status' do
      expect(Enrollment.completion_statuses.key?('finished')).to be_falsey
    end

    it 'is valid with valid completion_status' do
      enrollment.completion_status = 'in_progress'
      expect(enrollment).to be_valid
    end
  end
end
