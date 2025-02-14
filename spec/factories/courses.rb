FactoryBot.define do
  factory :course do
    title { "Learn Ruby on Rails" }
    description { "A comprehensive course on Ruby on Rails." }
    association :teacher, factory: :user, role: :teacher
    category
    price { 99.99 }
    level { 'beginner' }
    language { "English" }
    duration { 120 } # 2 hours
    created_at { Time.now }
    updated_at { Time.now }
  end
end
