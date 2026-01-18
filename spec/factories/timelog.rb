# frozen_string_literal: true

FactoryBot.define do
  factory :timelog do
    transient do
      owner { create(:user) }
      module_record { create(:uni_module, user: owner) }
    end

    uni_module { module_record }
    user { owner }
    date { Date.current }
    minutes { 30 }
    description { 'Worked on assignments' }
  end
end
