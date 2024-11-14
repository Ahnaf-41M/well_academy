class Course < ApplicationRecord
  belongs_to :teacher, class_name: "User"
  belongs_to :category
  has_many :lessons, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one :quiz

  has_one_attached :display_picture
  has_one_attached :syllabus
  has_one_attached :completion_certificate
  has_one_attached :achievement_certificate

  LEVEL = {beginner: 1, intermediate: 2, advanced: 3}.freeze 
  enum level: LEVEL

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :level, inclusion: { in: levels.keys }
  validates :language, presence: true
  validates :duration, presence: true
end
