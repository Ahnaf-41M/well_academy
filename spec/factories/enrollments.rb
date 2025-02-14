FactoryBot.define do
  factory :enrollment do
    student { association :user, role: 'student' }
    course
    enrolled_at { Time.now }
    progress { 0.0 }
    completion_status { 'not_started' }
  end
end
