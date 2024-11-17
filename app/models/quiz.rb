class Quiz < ApplicationRecord
  belongs_to :course
  has_many :questions, dependent: :destroy

  validates :title, presence: true
  validates :total_marks, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
