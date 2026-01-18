FactoryBot.define do
  factory :exam_result do
    user
    exam
    score { 75.5 }
  end
end
