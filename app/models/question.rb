class Question < ApplicationRecord
  belongs_to :quiz

  validates :content, :options, presence: true
  validates :marks, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
