# frozen_string_literal: true

# rubocop:disable Rails/HasAndBelongsToMany
class UniModule < AcademicUnit
  MAX_MODULES_PER_SEMESTER = 20

  has_and_belongs_to_many :semesters
  before_save :normalize_module_code
  after_commit :touch_semesters

  has_many :exams, dependent: :destroy
  has_many :timelogs, dependent: :destroy
  has_many :uni_module_targets, dependent: :destroy
  validate :semester_module_limit, on: :create

  # Gets the score you have got so far, ie. the score you would get if you stopped now
  def achieved_score(user)
    return final_score if final_score.present?

    valid_exams = exams_with_results(user)
    valid_exams.sum { |exam| exam.adjusted_score(user) * exam.weight / 100 }
  end

  def completed_credits(user)
    return 0 if exams.empty?

    completion_percentage(user) * credits / 100
  end

  # Required to override the parent class implementation
  def credits
    read_attribute(:credits) || 0
  end

  def weight
    return 0 if semesters.empty?
    (credits / semesters.sum(&:credits)) * semesters.sum(&:weight)
  end

  def normalize_module_code
    self.code = code.to_s.upcase
  end

  def credit_share
    return 0.0 if credits.nil?

    credits.to_f / semesters.size
  end

  def correct_weight_sum?
    exams.sum(:weight) == 100
  end

  # Gets the percentage completion of the module based on the exams taken
  def completion_percentage(user)
    return 100 if final_score.present?

    exams_with_results(user).sum(:weight)
  end

  alias progress completion_percentage

  def target(user)
    target = UniModuleTarget.find_by(user: user, uni_module: self)
    return nil if target.nil? || target.score.nil?

    target.score
  end

  def chart_color(index)
    color.presence || MODULE_COLORS[index % MODULE_COLORS.length]
  end

  private

  def touch_semesters
    # Can't use touch_all as that does't trigger callbacks
    semesters.each(&:touch)
  end

  def semester_module_limit
    return unless semesters.any? && semesters.first.uni_modules.count >= MAX_MODULES_PER_SEMESTER

    errors.add(:base, "You can only have up to #{MAX_MODULES_PER_SEMESTER} modules per semester.")
  end
end
# rubocop:enable Rails/HasAndBelongsToMany
