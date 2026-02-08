# frozen_string_literal: true

class Threshold < Exam
  # Override for path helpers
  def self.model_name
    Exam.model_name
  end

  def adjusted_score(user)
    t = threshold.presence || 70
    score(user) >= t ? 100 : 0
  end
end
