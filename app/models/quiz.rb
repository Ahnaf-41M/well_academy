class Quiz < ApplicationRecord
  belongs_to :course
  has_many :questions, dependent: :destroy
  has_many :quiz_participations, dependent: :destroy

  before_save :update_total_marks

  validates :title, presence: true
  validates :total_marks, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  private

  def update_total_marks
    if questions
      self.total_marks = questions.sum(:marks) # Sum the marks of all associated questions
    end
  end
end
