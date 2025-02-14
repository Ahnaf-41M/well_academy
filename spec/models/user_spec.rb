require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe "validations" do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it 'is not valid without a password' do
      user.password = nil
      expect(user).not_to be_valid
    end

    it 'is not valid without a name' do
      user.name = nil
      expect(user).not_to be_valid
    end
  end

  describe "roles" do
    it 'has a student role' do
      student_user = build(:user, :student)
      expect(student_user.role).to eq('student')
    end

    it 'has a teacher role' do
      teacher_user = build(:user, :teacher)
      expect(teacher_user.role).to eq('teacher')
    end

    it 'has an admin role' do
      admin_user = build(:user, :admin)
      expect(admin_user.role).to eq('admin')
    end
  end
end
