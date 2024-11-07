class Course < ApplicationRecord
  belongs_to :teacher, class_name: "User" # Association to the User model
  belongs_to :category
  has_many :lessons, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_one :quiz

  has_one_attached :display_picture
  has_one_attached :syllabus
  has_one_attached :completion_certificate
  has_one_attached :achievement_certificate

  enum level: %i[beginner intermediate advanced].freeze

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :level, inclusion: { in: levels.keys }
  validates :language, presence: true
  validates :duration, presence: true

  # def duration_hours
  #   duration ? duration / 1.hour : 0
  # end

  # def duration_minutes
  #   duration ? (duration % 1.hour) / 1.minute : 0
  # end

  def total_duration
    return "0 hours, 0 minutes" unless duration

    total_minutes = (duration / 1.minute).round
    hours = total_minutes / 60
    minutes = total_minutes % 60

    "#{hours} hour#{'s' if hours != 1}, #{minutes} minute#{'s' if minutes != 1}"
  end
end
