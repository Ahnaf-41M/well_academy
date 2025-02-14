FactoryBot.define do
  factory :quiz do
    title { "Geography Quiz" }
    total_marks { 100 }
    course
  end
end
