# frozen_string_literal: true

class Semester < ApplicationRecord
  MAX_SEMESTERS_PER_YEAR = 6

  has_many :uni_modules, dependent: :destroy
  belongs_to :year
  before_create :generate_share_token
  validate :year_semester_limit, on: :create

  def year_semester_limit
    if year.semesters.count >= MAX_SEMESTERS_PER_YEAR
      errors.add(:base, "You can only have up to #{MAX_SEMESTERS_PER_YEAR} semesters per year.")
    end
  end

  def credits 
    uni_modules.sum(:credits)
  end

  def weighted_average(user)
    valid_modules = uni_modules.reject { |m| m.weighted_average(user).nil? }
    if valid_modules.empty? then return 0 end
    total_weight = valid_modules.sum { |m| m.credits.to_i }
    weighted_sum = valid_modules.sum { |m| m.credits.to_i * m.weighted_average(user) }
    total_weight.zero? ? 0 : (weighted_sum / total_weight)
  end

  def achieved_score(user)
    total_weight = uni_modules.sum { |m| m.credits.to_i }
    weighted_sum = uni_modules.sum { |m| m.credits.to_i * m.achieved_score(user) }
    total_weight.zero? ? 0 : (weighted_sum / total_weight)
  end

  def progress(user)
    total_credits = uni_modules.sum(:credits)
    completed_credits = uni_modules.sum { |m| m.completion_percentage(user) * m.credits.to_i }
    total_credits.zero? ? 0 : (completed_credits / total_credits)
  end

  private

  def generate_share_token
    self.share_token ||= SecureRandom.urlsafe_base64(10)
  end
end
