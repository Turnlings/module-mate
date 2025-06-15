class Exam < ApplicationRecord
    belongs_to :uni_module

    def adjusted_score
        score
    end

    def target
        if !score.nil? || uni_module.target.nil?
            return nil
        end
        if uni_module.completion_percentage == 0
            return uni_module.target
        end
        (uni_module.target - uni_module.achieved_score)/(100-uni_module.completion_percentage)*100
    end
end
