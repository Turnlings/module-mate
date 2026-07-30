# frozen_string_literal: true

class Year < AcademicUnit
  MAX_YEARS_PER_USER = 10

  belongs_to :user, touch: true
  has_many :semesters, dependent: :destroy
  has_many :uni_modules, -> { distinct }, through: :semesters
  has_many :exams, through: :uni_modules
  has_many :exam_results, through: :exams
  has_many :timelogs, through: :uni_modules
  validate :user_year_limit, on: :create

  # The accumulated score of all the completed exams in this year
  def achieved_score(user)
    return final_score if final_score.present?

    return achieved_score_by_semester(user) if semesters.any? { |s| s.final_score.present? }

    achieved_score_by_module(user)
  end

  def completed_credits(user)
    return 0 if uni_modules.empty?

    uni_modules.sum { |m| m.credits.to_i * m.completion_percentage(user) / 100.0 }
  end

  def credits
    uni_modules.sum(&:credits)
  end

  def weight
    weighting_non_null / 100.0
  end

  def weighting_non_null
    return 0 if weighting.nil? || (uni_modules.empty? && final_score.nil?)

    weighting
  end

  # The percentage of credits completed by the user in this year

  private

  def achieved_score_by_semester(user)
    total_credits = semesters.sum { |s| s.credits.to_f }
    return 0 if total_credits.zero?

    weighted_sum = semesters.sum do |semester|
      semester.credits.to_f * semester_score_for_year(semester, user)
    end

    weighted_sum / total_credits
  end

  def semester_score_for_year(semester, user)
    return semester.final_score.to_f if semester.final_score.present?

    semester.achieved_score(user).to_f
  end

  def achieved_score_by_module(user)
    total_credits = uni_modules.sum { |m| m.credits.to_i }
    return 0 if total_credits.zero?

    weighted_sum = uni_modules.sum { |m| m.credits.to_i * m.achieved_score(user) }
    weighted_sum / total_credits
  end

  def user_year_limit
    return unless user.years.count >= MAX_YEARS_PER_USER

    errors.add(:base, "You can only have up to #{MAX_YEARS_PER_USER} years.")
  end
end
