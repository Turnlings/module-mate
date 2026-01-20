FactoryBot.define do
  factory :uni_module do
    transient do
      user { association(:user) }
      semesters { [] }
    end

    name { 'Introduction to Software Engineering' }
    code { 'COM1001' }
    credits { 20 }

    after(:create) do |uni_module, evaluator|
      uni_module.semesters << if evaluator.semesters.any?
                                evaluator.semesters
                              else
                                FactoryBot.create(:semester, user: evaluator.user)
                              end
    end
  end
end
