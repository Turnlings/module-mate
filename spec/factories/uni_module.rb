FactoryBot.define do
  factory :uni_module do

    transient do
      user { create(:user) }
    end

    name { "Introduction to Software Engineering" }
    code { "COM1001" }
    semester { create(:semester, year: create(:year, user: user)) }
  end
end
