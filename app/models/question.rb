class Question < ApplicationRecord
  belongs_to :quiz

  validates :content, presence: true
  validates :options, presence: true
  validates :marks, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
