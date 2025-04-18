class Lesson < ApplicationRecord
  belongs_to :course

  has_many :video_watches, dependent: :destroy

  has_one_attached :video, dependent: :purge
  has_one_attached :content

  validates :title, presence: true
  validates :order, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validate :correct_video_format

  before_save :adjust_order_within_course, if: :will_save_change_to_order?
  after_commit :update_course_duration, on: [ :create, :update, :destroy ]

  def video_duration
    return unless video.attached?
    video_path = ActiveStorage::Blob.service.send(:path_for, video.key)
    movie = FFMPEG::Movie.new(video_path)
    total_seconds = movie.duration

    minutes = (total_seconds / 60).to_i
    seconds = (total_seconds % 60).to_i
    "#{minutes}m #{seconds}s"
  end

  private

  def adjust_order_within_course
    lessons = course.lessons.where.not(id: id).order(:order)
    reordered_lessons = lessons.to_a.insert(order - 1, self).compact
    reordered_lessons.each_with_index do |lesson, index|
      lesson.update_column(:order, index + 1) unless lesson.order == index + 1
    end
  end

  def correct_video_format
    if video.attached? && !video.content_type.in?(%w[video/mp4 video/webm video/ogg])
      errors.add(:video, 'must be a video file (MP4, WebM, or Ogg)')
    end
  end

  def update_course_duration
    course.set_course_duration unless course.destroyed?
  end
end
