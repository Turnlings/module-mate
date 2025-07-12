# frozen_string_literal: true

class Semester < ApplicationRecord
  has_many :uni_modules, dependent: :destroy
  belongs_to :year

  before_create :generate_share_token

  def credits 
    uni_modules.sum(:credits)
  end

  def weighted_average(user)
    valid_modules = uni_modules.reject { |m| m.weighted_average(user).nil? }
    total_weight = valid_modules.sum(&:credits)
    weighted_sum = valid_modules.sum { |m| m.credits * m.weighted_average(user) }
    total_weight.zero? ? 0 : (weighted_sum / total_weight)
  end

  def achieved_score(user)
    total_weight = uni_modules.sum(&:credits)
    weighted_sum = uni_modules.sum { |m| m.credits * m.achieved_score(user) }
    total_weight.zero? ? 0 : (weighted_sum / total_weight)
  end

  private

  def generate_share_token
    self.share_token ||= SecureRandom.urlsafe_base64(10)
  end
end
