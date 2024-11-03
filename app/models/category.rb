class Category < ApplicationRecord
  has_many :courses
  validates :name, presence: true, uniqueness: true, case_sensitive: false, length: { maximum: 100 }
  validates :description, presence: true
end
