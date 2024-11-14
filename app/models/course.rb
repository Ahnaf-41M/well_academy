class Course < ApplicationRecord
  belongs_to :teacher, class_name: "User"
  belongs_to :category
  has_many :lessons, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_one :quiz

  has_one_attached :display_picture
  has_one_attached :syllabus
  has_one_attached :completion_certificate
  has_one_attached :achievement_certificate

  LEVEL = { beginner: 1, intermediate: 2, advanced: 3 }.freeze
  enum level: LEVEL

  validates :title, :description, :language, :duration, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def total_duration
    return "0 hours, 0 minutes" unless duration

    total_minutes = (duration / 1.minute).round
    hours = total_minutes / 60
    minutes = total_minutes % 60

    "#{hours} hour#{'s' if hours != 1}, #{minutes} minute#{'s' if minutes != 1}"
  end
end
