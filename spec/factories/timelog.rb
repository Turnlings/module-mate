# frozen_string_literal: true

FactoryBot.define do
  factory :timelog do
    user
    uni_module { association(:uni_module, user: user) }

    date { Date.current }
    minutes { 30 }
    description { 'Worked on assignments' }
  end
end
