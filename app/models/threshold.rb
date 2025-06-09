class Threshold < Exam
    # Override for path helpers
    def self.model_name
      Exam.model_name
    end

    def adjusted_score
      score >= 70 ? 100 : 0
    end

end