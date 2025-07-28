FactoryBot.define do
  factory :semester do
    transient do
      user { create(:user) }
    end

    name { "Semester 1" }

    year { create(:year, user: user) }
  end
end