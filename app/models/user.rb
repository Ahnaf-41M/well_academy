class User < ApplicationRecord
  before_create :generate_confirmation_token
  has_secure_password

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
end
