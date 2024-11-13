class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :course

  PAYMENT_TYPES = { mobile: 0, bank: 1 }.freeze
  enum payment_type: PAYMENT_TYPES

  STATUS_TYPES = { unpaid: 0, paid: 1 }.freeze
  enum status: STATUS_TYPES

  validates :course_price, presence: true
end
