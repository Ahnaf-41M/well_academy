FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    phone { "01234567890" }
    bio { "A test bio" }

    # Define the roles
    trait :student do
      role { 'student' }
    end

    trait :teacher do
      role { 'teacher' }
    end

    trait :admin do
      role { 'admin' }
    end
  end
end
