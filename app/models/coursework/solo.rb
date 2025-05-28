module Coursework
  class Solo < Exam
    # Override for path helpers
    def self.model_name
      Exam.model_name
    end
  end
end
