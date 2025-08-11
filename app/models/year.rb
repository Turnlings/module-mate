# frozen_string_literal: true

class Year < ApplicationRecord
  MAX_YEARS_PER_USER = 10

  belongs_to :user
  has_many :semesters, dependent: :destroy
  has_many :uni_modules, through: :semesters
  has_many :exams, through: :uni_modules
  validate :user_year_limit, on: :create

  def user_year_limit
    if user.years.count >= MAX_YEARS_PER_USER
      errors.add(:base, "You can only have up to #{MAX_YEARS_PER_USER} years.")
    end
  end

  def credits
    uni_modules.sum { |m| m.credit_share}
  end

  # The average of all the grades of the semesters in this year
  def weighted_average(user)
    return 0 if semesters.empty? || credits.zero?
    weighted_sum = semesters.sum { |s| s.credits * s.weighted_average(user) }
    weighted_sum / credits
  end

  # The percentage of credits completed by the user in this year
  def progress(user)
    # Calculate for each module: credit_share * completion_percentage
    completed_credits = uni_modules.sum { |m| m.credit_share * m.completion_percentage(user) / 100.0 }
    total_credits = uni_modules.sum { |m| m.credit_share }

    total_credits.zero? ? 0 : (completed_credits / total_credits) * 100
  end

  # The accumulated score of all the completed exams in this year
  def achieved_score(user)
    total_credits = uni_modules.sum { |m| m.credit_share }
    return 0 if total_credits.zero?

    weighted_sum = uni_modules.sum { |m| m.credit_share * m.achieved_score(user) }
    weighted_sum / total_credits
  end

  # Good enough with weighted average TODO: use exam results instead
  def average_score(user)
    return 0 if uni_modules.empty?
    uni_modules.sum { |m| m.weighted_average(user) } / uni_modules.count
  end
end
