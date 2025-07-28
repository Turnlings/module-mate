FactoryBot.define do
  factory :uni_module do
    transient do
      user { create(:user) }
    end

    name { "Introduction to Software Engineering" }
    code { "COM1001" }

    semester { create(:semester, user: user) }
  end
end