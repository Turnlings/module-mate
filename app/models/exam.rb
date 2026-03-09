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
    return if score(user) || uni_module.target(user).nil?

    module_target = uni_module.target(user)
    completion = uni_module.completion_percentage(user)
    achieved = uni_module.achieved_score(user)

    return module_target if completion.zero?

    (module_target - achieved) / (100 - completion) * 100
  end

  def estimated_score(user)
    return score(user) if score(user)

    estimated = estimated_score_value(user)
    estimated.positive? ? estimated : 0
  end

  def result(user)
    ExamResult.find_by(user: user, exam: self)
  end

  def time_until_due(date)
    return [0, 0, 0, 0] if due.nil? || date.nil? || due < date

    # Ensure both objects are valid date times

    return [0, 0, 0, 0] unless due.respond_to?(:to_time) && date.respond_to?(:to_time)

    difference = (due.to_time - date.to_time)
    mm, ss = difference.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)
    [dd, hh, mm, ss]
  end

  private

  def estimated_score_value(user)
    remaining_weight = weight.to_f / 100
    return 0 if remaining_weight.zero?

    score_without_this = estimated_score_without_this_exam(user)
    (uni_module.final_score.to_f - score_without_this) / remaining_weight
  end

  def estimated_score_without_this_exam(user)
    uni_module.exams.where.not(id: id).sum do |exam|
      exam.score(user).to_f * exam.weight / 100
    end
  end
end
