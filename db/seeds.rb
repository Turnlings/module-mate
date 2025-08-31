# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a user
user = User.create!(
  email: "student@example.com",
  password: "password123",
  password_confirmation: "password123"
)

# Add a year
year = user.years.create!(name: "Year 1")

# Add a semester
semester = year.semesters.create!(name: "Semester 1")

# Add 4 modules
modules = []
4.times do |i|
  modules << semester.uni_modules.create!(
    name: "Module #{i+1}",
    code: "MOD#{i+1}01"
  )
end

# Add timelogs for each module (4 weeks)
modules.each do |mod|
  28.times do |day_offset| # 4 weeks * 7 days
    # Random minutes per day (~0–180, averaging 90)
    minutes = [0, rand(15..180)].sample

    # Random timestamp for that day
    created_at = Date.today.beginning_of_week + day_offset + rand(0..23).hours + rand(0..59).minutes

    mod.timelogs.create!(
      user: user,
      minutes: minutes,
      created_at: created_at,
      updated_at: created_at
    )
  end
end