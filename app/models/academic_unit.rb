class AcademicUnit < ApplicationRecord
    self.abstract_class = true

    # AcademicUnit interface:
    # - AchievedScore
    # - PredictedScore
    # - Credits
    # - Weight
    # - TotalMinutes

    def achieved_score(user)
      raise NotImplementedError, "Subclasses must implement the achieved_score method"
    end

    def predicted_score(user)
      return final_score if final_score.present?
      return 0 if credits.zero?

      weighted_sum_predicted_score(user) / credits
    end

    def weighted_sum_predicted_score(user)
      raise NotImplementedError, "Subclasses must implement the weighted_sum_predicted_score method"
    end

    def progress(user)
      return 100 if final_score.present?

      credits.zero? ? 0 : (completed_credits / credits)
    end

    def completed_credits(user)
      raise NotImplementedError, "Subclasses must implement the completed_credits method"
    end

    def credits
      raise NotImplementedError, "Subclasses must implement the credits method"
    end

    def weight
      raise NotImplementedError, "Subclasses must implement the weight method"
    end

    def total_minutes(since_string = 'all')
      since = TimelogGraphService.date_of(since_string)

      scope = timelogs # Relies on the subclass defining 'has_many :timelogs'
      scope = Timelog.where(id: scope.select(:id))
      scope = scope.where(date: since..) if since.present?

      scope.sum(:minutes)
    end
end