class Lesson < ApplicationRecord
  belongs_to :course

  has_one_attached :video
  has_one_attached :content

  validates :title, :order, presence: true
  validates :video, content_type: { in: ['video/mp4', 'video/webm', 'video/ogg'], message: 'must be a video file (MP4, WebM, or Ogg)' }

  def video_duration
    return unless video.attached?
    video_path = ActiveStorage::Blob.service.send(:path_for, video.key)
    movie = FFMPEG::Movie.new(video_path)
    total_seconds = movie.duration

    minutes = (total_seconds / 60).to_i
    seconds = (total_seconds % 60).to_i
    "#{minutes}m #{seconds}s"
  end

end
