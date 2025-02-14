class Review < ApplicationRecord
  belongs_to :course
  belongs_to :student, class_name: "User"

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, length: { maximum: 1000 }, allow_blank: true
end
