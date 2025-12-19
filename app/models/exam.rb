# frozen_string_literal: true

class Exam < ApplicationRecord
  MAX_EXAMS_PER_MODULE = 20

  belongs_to :uni_module, touch: true
  has_many :users, through: :exam_results
  has_many :exam_results, dependent: :destroy
  validate :module_exam_limit, on: :create

  def module_exam_limit
    return unless uni_module.exams.count >= MAX_EXAMS_PER_MODULE

    errors.add(:base, "You can only have up to #{MAX_EXAMS_PER_MODULE} exams per module.")

  end

  def score(user)
    result = ExamResult.find_by(user: user, exam: self)
    return nil if result.nil?

    result.score
  end

  def adjusted_score(user)
    score(user)
  end

  def target(user)
    return nil if !score(user).nil? || uni_module.target(user).nil?
    return uni_module.target(user) if uni_module.completion_percentage(user).zero?

    (uni_module.target(user) - uni_module.achieved_score(user)) / (100 - uni_module.completion_percentage(user)) * 100
  end

  def result(user)
    ExamResult.find_by(user: user, exam: self)
  end

  def time_until_due(date)
    unless due.nil?
      difference = (due - date)
      mm, ss = difference.divmod(60)
      hh, mm = mm.divmod(60)
      dd, hh = hh.divmod(24)
      return [dd, hh, mm, ss]
    end
    [0, 0, 0, 0]

  end
end
