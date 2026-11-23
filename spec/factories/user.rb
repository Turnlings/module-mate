# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }

    after(:build) do |user|
      user.skip_confirmation!
    end
  end
end
