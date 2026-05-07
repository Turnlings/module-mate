# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#predicted_score (edge cases)' do
    let(:user) { create(:user) }

    it 'handles partial module completion within a year' do
      year = create(:year, user: user, final_score: nil, weighting: 100)
      semester = create(:semester, year: year, user: user)
      mod1 = create(:uni_module, semesters: [semester], user: user, credits: 10)
      mod2 = create(:uni_module, semesters: [semester], user: user, credits: 10)
      exam1 = create(:exam, uni_module: mod1, weight: 100)
      create(:exam, uni_module: mod2, weight: 100)
      create(:exam_result, user: user, exam: exam1, score: 80)
      # mod2 has no results
      # Only mod1 is counted, so predicted_score = 80
      expect(user.predicted_score).to eq(80)
    end

    it 'handles multiple years with some modules completed and some with final_score' do
      create(:year, user: user, final_score: 90, weighting: 60)
      year2 = create(:year, user: user, final_score: nil, weighting: 40)
      semester2 = create(:semester, year: year2, user: user)
      mod2a = create(:uni_module, semesters: [semester2], user: user, credits: 10)
      mod2b = create(:uni_module, semesters: [semester2], user: user, credits: 10)
      exam2a = create(:exam, uni_module: mod2a, weight: 100)
      create(:exam, uni_module: mod2b, weight: 100)
      create(:exam_result, user: user, exam: exam2a, score: 80)
      # mod2b has no results
      # year2 predicted = 80, so user.predicted_score = (90*0.6)+(80*0.4)
      expect(user.predicted_score).to eq((90 * 0.6) + (80 * 0.4))
    end

    it 'returns correct score when all years have final_score' do
      create(:year, user: user, final_score: 85, weighting: 50)
      create(:year, user: user, final_score: 95, weighting: 50)
      # predicted_score = (85*0.5)+(95*0.5) = 90
      expect(user.predicted_score).to eq(90)
    end
  end
end
