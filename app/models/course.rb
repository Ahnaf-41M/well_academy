class Course < ApplicationRecord
  belongs_to :teacher, class_name: "User"
  belongs_to :category

  has_one :quiz, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :enrollments, dependent: :destroy

  has_one_attached :display_picture
  has_one_attached :syllabus
  has_one_attached :completion_certificate
  has_one_attached :achievement_certificate

  enum level: { beginner: 1, intermediate: 2, advanced: 3 }

  validates :title, :description, :language, :duration, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def total_duration
    return "0 hours, 0 minutes" unless duration

    total_minutes = (duration / 1.minute).round
    hours = total_minutes / 60
    minutes = total_minutes % 60

    "#{hours} hour#{'s' if hours != 1}, #{minutes} minute#{'s' if minutes != 1}"
  end

  def set_course_duration
    return if destroyed? || frozen?
    new_duration = 0

    lessons.each do |lesson|
      if lesson.video.attached?
        video_path = ActiveStorage::Blob.service.path_for(lesson.video.key)

        if File.exist?(video_path)
          movie = FFMPEG::Movie.new(video_path)
          new_duration += movie.duration
        end
      end
    end

    update_column(:duration, new_duration) if duration
  end
end
