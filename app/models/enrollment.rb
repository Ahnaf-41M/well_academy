class Enrollment < ApplicationRecord
  belongs_to :student, class_name: "User"
  belongs_to :course

  STATUS = {not_started: 1, in_progress: 2, completed: 3}.freeze
  enum completion_status: STATUS

  validates :enrolled_at, presence: true
  validates :progress, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 100.0 }
  validates :completion_status, inclusion: { in: completion_statuses.keys }
end
