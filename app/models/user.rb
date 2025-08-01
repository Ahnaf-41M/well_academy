class User < ApplicationRecord
  has_secure_password
  before_create :generate_confirmation_token

  # Student association
  has_many :enrollments, foreign_key: :student_id, dependent: :destroy
  has_many :enrolled_courses, through: :enrollments, source: :course

  # Teacher association
  has_many :courses, foreign_key: :teacher_id, dependent: :destroy

  has_many :video_watches, dependent: :destroy
  has_many :watched_lessons, through: :video_watches, source: :lesson, dependent: :destroy
  has_many :reviews, foreign_key: :student_id, dependent: :destroy
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

  def completed_courses
    enrolled_courses
      .where("courses.lessons_count = (
        SELECT COUNT(*)
        FROM video_watches
        INNER JOIN lessons ON video_watches.lesson_id = lessons.id
        WHERE courses.id = lessons.course_id
        AND video_watches.user_id = ?)", id)
      .where("courses.lessons_count > 0")
  end

  def courses_with_quiz_participation
    enrolled_courses.joins(quiz: :quiz_participations)
                    .where(quiz_participations: { student_id: id })
                    .where("(quiz_participations.marks_obtained::float / quiz_participations.total_marks) >= 0.3")
  end

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
