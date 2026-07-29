# frozen_string_literal: true

# rubocop:disable Rails/HasAndBelongsToMany
class Semester < AcademicUnit
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

    total_weight = uni_modules.sum(&:credit_share)
    weighted_sum = uni_modules.includes(exams: :exam_results).sum { |m| m.credit_share * m.achieved_score(user) }
    total_weight.zero? ? 0 : (weighted_sum / total_weight)
  end

  def weighted_sum_predicted_score(user)
    uni_modules.includes(exams: :exam_results).sum { |m| m.credit_share * m.predicted_score(user) }
  end

  def completed_credits(user)
    uni_modules.sum { |m| m.completion_percentage(user) * m.credit_share }
  end

  def credits
    return 0 if uni_modules.empty?

    uni_modules.sum(&:credit_share)
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
