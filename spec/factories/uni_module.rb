FactoryBot.define do
  factory :uni_module do
    transient do
      user { create(:user) }
      semesters { [] }
    end

    name { 'Introduction to Software Engineering' }
    code { 'COM1001' }
    credits { 20 }

    after(:create) do |uni_module, evaluator|
      if evaluator.semesters.any?
        evaluator.semesters.each do |semester|
          uni_module.semesters << semester
        end
      else
        # create a semester only if none given
        uni_module.semesters << create(:semester, user: evaluator.user)
      end
    end
  end
end
