class UniModule < ApplicationRecord
  has_many :exams
  has_many :timelogs

  before_save :normalize_module_code

  def normalize_module_code
    self.code = code.to_s.upcase
  end

  def weighted_average
    valid_exams = exams.select { |exam| !exam.score.nil? }
    total_weight = valid_exams.sum(&:weight)
    weighted_sum = valid_exams.sum { |exam| exam.weight * exam.score }
    total_weight.zero? ? 0 : (weighted_sum / total_weight)
  end
end
