FactoryBot.define do
  factory :payment do
    user  # Assumes you have a user factory defined
    course  # Assumes you have a course factory defined
    course_price { 100.00 }
    payment_type { :bank }
    status { :unpaid }

    created_at { Time.current }
    updated_at { Time.current }
  end
end
