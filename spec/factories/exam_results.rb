FactoryBot.define do
  factory :exam_result do
    association :user
    association :exam
    score { 75.5 }
  end
end
