FactoryBot.define do
  factory :lesson do
    title { "Lesson 1: Introduction" }
    order { 1 }
    course
  end
end
