class Lesson < ApplicationRecord
  belongs_to :course

  has_one_attached :video
  has_one_attached :content

  validates :title, presence: true
  validates :order, presence: true

  before_save :adjust_order_within_course, if: :will_save_change_to_order?

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

end
