class Semester < ApplicationRecord
  has_many :uni_modules, dependent: :destroy
  belongs_to :year

  def weighted_average
    valid_modules = uni_modules.select { |m| !m.weighted_average.nil? }
    total_weight = valid_modules.sum(&:credits)
    weighted_sum = valid_modules.sum { |m| m.credits * m.weighted_average }
    total_weight.zero? ? 0 : (weighted_sum / total_weight)
  end
end
