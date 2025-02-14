class QuizParticipation < ApplicationRecord
  belongs_to :student, class_name: "User"
  belongs_to :quiz

  validates :marks_obtained, presence: true, numericality: { only_integer: true }
  validates :total_marks, presence: true, numericality: { only_integer: true }
end
