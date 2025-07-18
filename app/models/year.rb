# frozen_string_literal: true

class Year < ApplicationRecord
  has_many :semesters, dependent: :destroy
  belongs_to :user

  def credits
    semesters.includes(:uni_modules).sum { |s| s.credits }
  end

  # The average of all the grades of the semesters in this year
  def weighted_average(user)
    return 0 if semesters.empty?
    total_weight = semesters.sum { |s| s.credits }
    weighted_sum = semesters.sum { |s| s.credits * s.weighted_average(user) }
    total_weight.zero? ? 0 : (weighted_sum / total_weight)
  end

  # The percentage of credits completed by the user in this year
  def progress(user)
    return 0 if semesters.empty?
    completed_credits = semesters.sum { |s| s.progress(user) }
    completed_credits / semesters.count
  end

  # The accumulated score of all the completed exams in this year
  def achieved_score(user)
    return 0 if semesters.empty?
    semesters.sum { |semester| semester.achieved_score(user) } / semesters.size
  end
end
