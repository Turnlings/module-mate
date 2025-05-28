class UniModule < ApplicationRecord
  belongs_to :semester, optional: true
  has_many :exams
  has_many :timelogs

  before_save :normalize_module_code

  def normalize_module_code
    self.code = code.to_s.upcase
  end

  # Gets the average score of all of the completed exams so far, weighted by credits
  def weighted_average
    valid_exams = exams.select { |exam| !exam.score.nil? }
    total_weight = valid_exams.sum(&:weight)
    weighted_sum = valid_exams.sum { |exam| exam.weight * exam.score }
    total_weight.zero? ? 0 : (weighted_sum / total_weight)
  end

  # Gets the percentage completion of the module based on the exams taken
  def completion_percentage
    return 0 if exams.empty?
    valid_exams = exams.select { |exam| !exam.score.nil? }
    completion = valid_exams.sum(&:weight)
  end
end
