class User < ApplicationRecord
  before_create :generate_confirmation_token
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
