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
      raise NotImplementedError, "Subclasses must implement the predicted_score method"
    end

    def credits
      raise NotImplementedError, "Subclasses must implement the credits method"
    end

    def weight
      raise NotImplementedError, "Subclasses must implement the weight method"
    end

    def total_minutes(since_string = 'all')
      raise NotImplementedError, "Subclasses must implement the total_minutes method"
    end
end