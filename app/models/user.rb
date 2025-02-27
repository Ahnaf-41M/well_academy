class User < ApplicationRecord
  has_secure_password
  before_create :generate_confirmation_token

  has_many :courses, foreign_key: :teacher_id, dependent: :destroy
  has_many :video_watches, dependent: :destroy
  has_many :watched_lessons, through: :video_watches, source: :lesson, dependent: :destroy
  has_many :reviews, foreign_key: :student_id, dependent: :destroy
  has_many :enrollments, foreign_key: :student_id, dependent: :destroy
  has_many :quiz_participations, foreign_key: :student_id, dependent: :destroy
  has_many :payments, dependent: :destroy

  has_one_attached :profile_picture
  has_many_attached :student_certificates
  has_one_attached :grad_certificate
  has_one_attached :postgrad_certificate

  enum role: { student: 0, teacher: 1, admin: 2 }

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true
  validates :phone, length: { is: 11 }, allow_blank: true

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.hex(10)
  end

  def generate_password_reset_token!
    update!(
      reset_password_token: SecureRandom.urlsafe_base64,
      reset_password_sent_at: Time.current
    )
  end

  def password_reset_token_expired?
    reset_password_sent_at < 2.hours.ago
  end
end
