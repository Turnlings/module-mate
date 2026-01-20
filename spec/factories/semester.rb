FactoryBot.define do
  factory :semester do
    transient do
      user { association(:user) }
    end

    name { 'Semester 1' }

    year { association(:year, user: user) }
  end
end
