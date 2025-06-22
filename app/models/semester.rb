# frozen_string_literal: true

class Semester < ApplicationRecord
  has_many :uni_modules, dependent: :destroy
  belongs_to :year

  def weighted_average(user)
    valid_modules = uni_modules.reject { |m| m.weighted_average(user).nil? }
    total_weight = valid_modules.sum(&:credits)
    weighted_sum = valid_modules.sum { |m| m.credits * m.weighted_average(user) }
    total_weight.zero? ? 0 : (weighted_sum / total_weight)
  end
end
