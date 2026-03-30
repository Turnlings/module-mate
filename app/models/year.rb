# frozen_string_literal: true

class Year < ApplicationRecord
  MAX_YEARS_PER_USER = 10

  belongs_to :user, touch: true
  has_many :semesters, dependent: :destroy
  has_many :uni_modules, -> { distinct }, through: :semesters
  has_many :exams, through: :uni_modules
  has_many :exam_results, through: :exams
  has_many :timelogs, through: :uni_modules
  validate :user_year_limit, on: :create

  def user_year_limit
    return unless user.years.count >= MAX_YEARS_PER_USER

    errors.add(:base, "You can only have up to #{MAX_YEARS_PER_USER} years.")
  end

  def credits
    semesters.sum(&:credits)
  end

  def total_minutes(since_string = 'all')
    # When a module is associated to multiple semesters, the join behind
    # `timelogs` can duplicate rows and cause sums to be inflated.
    # Dedupe by timelog id before aggregating.
    since = TimelogGraphService.date_of(since_string)

    scope = Timelog.where(id: timelogs.select(:id))
    scope = scope.where(date: since..) if since.present?

    scope.sum(:minutes)
  end

  # The average of all the grades of the semesters in this year
  def weighted_average(user)
    return 0 if semesters.empty? || credits.zero?

    weighted_sum = semesters.sum { |s| s.credits * s.weighted_average(user) }
    weighted_sum / credits
  end

  def weighting_non_null
    return 0 if weighting.nil? || (uni_modules.empty? && final_score.nil?)

    weighting
  end

  def completed_credits(user)
    return 0 if uni_modules.empty?

    uni_modules.sum { |m| m.credits.to_i * m.completion_percentage(user) / 100.0 }
  end

  # The percentage of credits completed by the user in this year
  def progress(user)
    return 100 if final_score.present?

    completed_credits = completed_credits(user)
    total_credits = uni_modules.sum { |m| m.credits.to_i }

    total_credits.zero? ? 0 : (completed_credits / total_credits) * 100
  end

  def predicted_score(user)
    return final_score if final_score.present?

    # Use achieved_score for completed portion, extrapolate for the rest
    progress = self.progress(user) / 100.0
    return 0 if progress.zero?

    achieved = achieved_score(user)

    (achieved / progress).clamp(0, 100)
  end

  # The accumulated score of all the completed exams in this year
  def achieved_score(user)
    return final_score if final_score.present?

    return achieved_score_by_semester(user) if semesters.any? { |s| s.final_score.present? }

    achieved_score_by_module(user)
  end

  # Good enough with weighted average TODO: use exam results instead
  def average_score(_user)
    return 0 if exam_results.empty?

    scores = exam_results.map(&:score).compact
    scores.sum.to_f / scores.size
  end

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
end
