FactoryBot.define do
  factory :year do
    name { 'First Year' }
    association :user
  end
end
