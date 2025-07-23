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
    uni_modules.sum(:credits)
  end

  # The average of all the grades of the semesters in this year
  def weighted_average(user)
    return 0 if semesters.empty? || credits.zero?
    weighted_sum = semesters.sum { |s| s.credits * s.weighted_average(user) }
    weighted_sum / credits
  end

  # The percentage of credits completed by the user in this year
  def progress(user)
    # return 0 if semesters.empty?
    # completed_credits = semesters.sum { |s| s.progress(user) }
    # completed_credits / semesters.count

    # completed = exams.joins(:exam_results).where(exam_results: { user_id: user.id }).distinct.sum(:weight)
    # total = exams.sum(:weight)

    completed = ExamResult
      .joins(exam: :uni_module)
      .where(exam: exams, user: user)
      .sum(<<~SQL.squish)
        exams.weight
        * uni_modules.credits
      SQL

    total = exams
      .joins(:uni_module)
      .sum(<<~SQL.squish)
        exams.weight
        * uni_modules.credits
      SQL

    total.zero? ? 0 : (completed.to_f / total.to_f) * 100
  end

  # The accumulated score of all the completed exams in this year
  def achieved_score(user)
    return 0 if credits.zero?

    scores = ExamResult
      .joins(exam: :uni_module)
      .where(exam: exams, user: user)
      .sum(<<~SQL.squish)
        exam_results.score
        * exams.weight
        * uni_modules.credits
        / 100.0
      SQL

    scores / credits
  end
end
