class Course < ApplicationRecord
  belongs_to :teacher, class_name: "User"  # Association to the User model
  belongs_to :category

  has_one_attached :completion_certificate
  has_one_attached :achievement_certificate

  enum level: %i[beginner intermediate advanced].freeze

  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :level, inclusion: { in: levels.keys }
  validates :language, presence: true
  validates :duration, presence: true

  def duration_hours
    duration ? duration / 1.hour : 0
  end

  def duration_minutes
    duration ? (duration % 1.hour) / 1.minute : 0
  end
end
