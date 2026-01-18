FactoryBot.define do
  factory :exam do
    transient do
      user { nil }
    end

    uni_module { association :uni_module, user: user }

    name { 'Final Exam' }
    weight { 50 }
  end
end
