# frozen_string_literal: true

class Year < AcademicUnit
  include Hashid::Rails

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

    semesters_list = semesters.to_a

    Rails.cache.fetch([self, "achieved_score_#{user.id}"]) do
      return achieved_score_by_semester(user, semesters_list) if semesters_list.any? do |semester|
        semester.final_score.present?
      end

      achieved_score_by_module(user)
    end
  end

  def predicted_score(user)
    return final_score if final_score.present?

    Rails.cache.fetch([self, 'predicted_score', user.id]) do
      sems = semesters.includes(uni_modules: { exams: :exam_results }).to_a

      total_weight = 0
      weighted_sum = 0

      sems.each do |semester|
        semester_weight = semester.weight * semester.progress(user) / 100.0
        total_weight += semester_weight
        weighted_sum += semester_weight * semester.predicted_score(user)
      end

      total_weight.zero? ? 0 : (weighted_sum / total_weight)
    end
  end

  def completed_credits(user)
    return 0 if uni_modules.empty?
    return credits if final_score.present?

    semesters.sum { |semester| semester.completed_credits(user) }
  end

  def credits
    semesters.sum(&:credits)
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

  def achieved_score_by_semester(user, semesters_list = semesters.to_a)
    total_credits = semesters_list.sum { |semester| semester.credits.to_f }
    return 0 if total_credits.zero?

    weighted_sum = semesters_list.sum do |semester|
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
