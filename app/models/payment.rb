class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :course

  enum payment_type: %i[mobile bank].freeze
  enum status: %i[unpaid paid].freeze

  validates :course_price, presence: true
end
