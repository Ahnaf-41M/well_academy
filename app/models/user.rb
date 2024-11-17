class User < ApplicationRecord
  has_secure_password
  has_many :video_watches
  has_many :watched_lessons, through: :video_watches, source: :lesson
  has_many :reviews, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_one_attached :profile_picture
  has_many_attached :student_certificates
  has_one_attached :grad_certificate
  has_one_attached :postgrad_certificate

  enum role: %i[student teacher admin].freeze

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, inclusion: { in: roles.keys }

  def pic_resize(x, y)
    x = x.to_i
    y = y.to_i
    # puts "\n\n ***Converted x: #{x}, Converted y: #{y}" # Debugging line

    profile_picture.variant(resize_to_limit: [ x, y ])
  end
end
