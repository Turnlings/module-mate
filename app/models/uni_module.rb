# frozen_string_literal: true

class UniModule < ApplicationRecord
  belongs_to :semester, optional: true
  has_many :exams, dependent: :destroy
  has_many :timelogs, dependent: :destroy
  has_many :uni_module_targets, dependent: :destroy

  before_save :normalize_module_code

  def normalize_module_code
    self.code = code.to_s.upcase
  end

  def exams_with_results(user)
    exams.joins(:exam_results).where(exam_results: { user_id: user.id }).distinct
  end

  # Gets the average score of all of the completed exams so far, weighted by credits
  def weighted_average(user)
    valid_exams = exams_with_results(user)
    total_weight = valid_exams.sum(&:weight)
    weighted_sum = valid_exams.sum { |exam| exam.weight * exam.adjusted_score(user) }
    total_weight.zero? ? 0 : (weighted_sum / total_weight)
  end

  # Gets the score you have got so far, ie. the score you would get if you stopped now
  def achieved_score(user)
    valid_exams = exams_with_results(user)
    valid_exams.sum { |exam| exam.adjusted_score(user) * exam.weight / 100 }
  end

  # Gets the percentage completion of the module based on the exams taken
  def completion_percentage(user)
    return 0 if exams.empty?

    exams_with_results(user).sum(&:weight)
  end

  def target(user)
    target = UniModuleTarget.find_by(user: user, uni_module: self)
    return nil if target.nil? || target.score.nil?

    target.score
  end
end
