class Question < ApplicationRecord
  belongs_to :quiz
  has_many :options, dependent: :destroy

  validates :content, :options, presence: true
  validates :marks, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
