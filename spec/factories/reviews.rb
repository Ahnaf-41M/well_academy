FactoryBot.define do
  factory :review do
    course
    association :student, factory: :user
    rating { 5 }
    comment { "This course was excellent!" }

    created_at { Time.current }
    updated_at { Time.current }
  end
end
