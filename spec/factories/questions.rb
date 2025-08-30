FactoryBot.define do
  factory :question do
    content { "What is Ruby?" }
    marks { 5 }
    quiz
    options { [ { "option_text" => "Ruby", "is_correct" => "1" }, { "option_text" => "Python", "is_correct" => "0" } ] }
  end
end
