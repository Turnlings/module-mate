class AcademicUnit < ApplicationRecord
  self.abstract_class = true

  def achieved_score(user)
    raise NotImplementedError, 'Subclasses must implement the achieved_score method'
  end

  def weighted_average_completed(user)
    return final_score if final_score.present?
    return 0 if completed_credits(user).zero?

    completed_exams = exams_with_results(user)
    score = completed_exams.sum { |exam| exam.adjusted_score(user) * exam.total_weight }
    completed_weight = completed_exams.sum(&:total_weight)

    score / completed_weight
  end

  alias predicted_score weighted_average_completed

  def progress(user)
    return 100 if final_score.present?

    Rails.cache.fetch([self, 'progress', user.id]) do
      credits.zero? ? 0 : (completed_credits(user) / credits) * 100
    end
  end

  def completed_credits(user)
    raise NotImplementedError, 'Subclasses must implement the completed_credits method'
  end

  def credits
    raise NotImplementedError, 'Subclasses must implement the credits method'
  end

  def weight
    raise NotImplementedError, 'Subclasses must implement the weight method'
  end

  def total_minutes(since_string = 'all')
    since = TimelogGraphService.date_of(since_string)

    scope = timelogs # Relies on the subclass defining 'has_many :timelogs'
    scope = Timelog.where(id: scope.select(:id))
    scope = scope.where(date: since..) if since.present?

    scope.sum(:minutes)
  end

  def average_time_per_credit(since_string = 'all')
    return 0 if credits.zero?

    total_minutes(since_string) / credits
  end

  def average_time_per_day
    first_log_date = timelogs.minimum(:date)
    return nil unless first_log_date

    latest_log_date = timelogs.maximum(:date)
    return nil unless latest_log_date

    days_since_first_log = (latest_log_date - first_log_date).to_i + 1 # Inclusive
    return total_minutes if days_since_first_log.zero?

    total_minutes.to_f / days_since_first_log
  end

  def exams_with_results(user)
    exams.eager_load(:exam_results)
         .where(exam_results: { user_id: user.id })
         .where.not(exam_results: { score: nil })
  end
end
