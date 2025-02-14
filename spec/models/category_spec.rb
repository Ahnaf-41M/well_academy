require "rails_helper"

RSpec.describe Category, type: :model do
  let(:category) { FactoryBot.build(:category) }

  describe 'validations' do
    it 'is not valid without a name' do
      category.name = nil
      expect(category).not_to be_valid
    end

    it 'is not valid without a description' do
      category.description = nil
      expect(category).not_to be_valid
    end

    it 'is not valid with a duplicate name' do
      FactoryBot.create(:category) # Create the first category (stores it in database)
      duplicate_category = FactoryBot.build(:category) # Attempt to create a duplicate
      expect(duplicate_category).not_to be_valid
    end

    it 'is not valid if name is too long (greater than 100)' do
      category.name = 'a' * 101  # Assuming the maximum length is 100
      expect(category).not_to be_valid
    end
  end
end
