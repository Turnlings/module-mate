class Exam < ApplicationRecord
    belongs_to :uni_module

    def adjusted_score
        score
    end
end
