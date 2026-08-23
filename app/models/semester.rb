# frozen_string_literal: true

# rubocop:disable Rails/HasAndBelongsToMany
class Semester < AcademicUnit
  include Hashid::Rails

  MAX_SEMESTERS_PER_YEAR = 6

  belongs_to :year, touch: true
  has_and_belongs_to_many :uni_modules, dependent: :destroy
  has_many :exams, through: :uni_modules
  has_many :exam_results, through: :exams
  has_many :timelogs, through: :uni_modules
  before_create :generate_share_token
  validate :year_semester_limit, on: :create

  def achieved_score(user)
    return final_score if final_score.present?

    Rails.cache.fetch([self, 'achieved_score', user.id]) do
      modules_list = uni_modules.includes(exams: :exam_results).to_a

      total_weight = modules_list.sum(&:credit_share)
      weighted_sum = modules_list.sum do |mod|
        mod.credit_share * mod.achieved_score(user)
      end

      total_weight.zero? ? 0 : weighted_sum / total_weight
    end
  end

  def predicted_score(user)
    return final_score if final_score.present?

    Rails.cache.fetch([self, 'predicted_score', user.id]) do
      modules_list = uni_modules.includes(exams: :exam_results).to_a

      total_weight = 0
      weighted_sum = 0

      modules_list.each do |mod|
        module_weight = mod.credit_share * mod.progress(user) / 100.0
        total_weight += module_weight
        weighted_sum += module_weight * mod.predicted_score(user)
      end

      total_weight.zero? ? 0 : (weighted_sum / total_weight)
    end
  end

  def completed_credits(user)
    uni_modules.sum { |m| m.completion_percentage(user) / 100 * m.credit_share }
  end

  def credits
    return 0 if uni_modules.empty?

    Rails.cache.fetch([self, 'credits']) do
      uni_modules.sum(&:credit_share)
    end
  end

  def weight
    year.weight * credits / year.credits
  end

  private

  def generate_share_token
    self.share_token ||= SecureRandom.urlsafe_base64(10)
  end

  def year_semester_limit
    return unless year

    return unless year.semesters.count >= MAX_SEMESTERS_PER_YEAR

    errors.add(:base, "You can only have up to #{MAX_SEMESTERS_PER_YEAR} semesters per year.")
  end
end
# rubocop:enable Rails/HasAndBelongsToMany
