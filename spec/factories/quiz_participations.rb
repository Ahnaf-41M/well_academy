FactoryBot.define do
  factory :quiz_participation do
    association :student, factory: :user
    quiz
    marks_obtained { 80 }
    total_marks { 100 }
    submitted_at { Time.current }
  end
end
