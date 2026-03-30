# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe '#predicted_score' do
    let(:user) { create(:user) }

    it 'returns 0 if there are no years' do
      expect(user.predicted_score).to eq(0)
    end

    it 'calculates predicted score by extrapolating each year based on real data' do
      year1 = create(:year, user: user, final_score: nil, weighting: 50)
      year2 = create(:year, user: user, final_score: nil, weighting: 50)
      semester1 = create(:semester, year: year1, user: user)
      semester2 = create(:semester, year: year2, user: user)
      mod1 = create(:uni_module, semesters: [semester1], user: user)
      mod2 = create(:uni_module, semesters: [semester2], user: user)
      exam1 = create(:exam, uni_module: mod1, weight: 100)
      create(:exam, uni_module: mod2, weight: 50)
      create(:exam_result, user: user, exam: exam1, score: 85)

      expected_predicted_score = 85
      expect(user.predicted_score).to eq(expected_predicted_score)
    end

    it 'returns 0 when progress is 0' do
      create(:year, user: user, final_score: nil, weighting: 100)

      allow(user).to receive_messages(achieved_score: 85, progress: 0)

      expect(user.predicted_score).to eq(0)
    end

    it 'predicts correctly when all years have full progress and same scores' do
      year1 = create(:year, user: user, final_score: nil, weighting: 50)
      year2 = create(:year, user: user, final_score: nil, weighting: 50)
      semester1 = create(:semester, year: year1, user: user)
      semester2 = create(:semester, year: year2, user: user)
      mod1 = create(:uni_module, semesters: [semester1], user: user)
      mod2 = create(:uni_module, semesters: [semester2], user: user)
      exam1 = create(:exam, uni_module: mod1, weight: 100)
      exam2 = create(:exam, uni_module: mod2, weight: 100)
      create(:exam_result, user: user, exam: exam1, score: 70)
      create(:exam_result, user: user, exam: exam2, score: 70)

      expect(user.predicted_score).to eq(70)
    end

    it 'predicts correctly when years have different progress and scores' do
      year1 = create(:year, user: user, final_score: nil, weighting: 60)
      year2 = create(:year, user: user, final_score: nil, weighting: 40)
      semester1 = create(:semester, year: year1, user: user)
      semester2 = create(:semester, year: year2, user: user)
      mod1 = create(:uni_module, semesters: [semester1], user: user)
      mod2 = create(:uni_module, semesters: [semester2], user: user)
      exam1 = create(:exam, uni_module: mod1, weight: 100)
      exam2 = create(:exam, uni_module: mod2, weight: 100)
      create(:exam_result, user: user, exam: exam1, score: 80)
      create(:exam_result, user: user, exam: exam2, score: 90)

      expect(user.predicted_score).to eq((80 * 0.6) + (90 * 0.4))
    end

    it 'ignores years with zero progress in prediction' do
      year1 = create(:year, user: user, final_score: nil, weighting: 70)
      year2 = create(:year, user: user, final_score: nil, weighting: 30)
      semester1 = create(:semester, year: year1, user: user)
      semester2 = create(:semester, year: year2, user: user)
      mod1 = create(:uni_module, semesters: [semester1], user: user)
      create(:uni_module, semesters: [semester2], user: user)
      exam1 = create(:exam, uni_module: mod1, weight: 100)
      create(:exam_result, user: user, exam: exam1, score: 75)
      # year2 has no progress

      expect(user.predicted_score).to eq(75)
    end

    it 'ignores years with zero modules in prediction' do
      year1 = create(:year, user: user, final_score: nil, weighting: 70)
      create(:year, user: user, final_score: nil, weighting: 30)
      semester1 = create(:semester, year: year1, user: user)
      mod1 = create(:uni_module, semesters: [semester1], user: user)
      exam1 = create(:exam, uni_module: mod1, weight: 100)
      create(:exam_result, user: user, exam: exam1, score: 75)
      # year2 has no progress

      expect(user.predicted_score).to eq(75)
    end

    it 'uses final_score for years that have it' do
      create(:year, user: user, final_score: 88, weighting: 60)
      year2 = create(:year, user: user, final_score: nil, weighting: 40)
      semester2 = create(:semester, year: year2, user: user)
      mod2 = create(:uni_module, semesters: [semester2], user: user)
      exam2 = create(:exam, uni_module: mod2, weight: 100)
      create(:exam_result, user: user, exam: exam2, score: 92)

      expect(user.predicted_score).to eq((88 * 0.6) + (92 * 0.4))
    end

    it 'returns 0 if all years have zero progress' do
      create(:year, user: user, final_score: nil, weighting: 50)
      create(:year, user: user, final_score: nil, weighting: 50)

      expect(user.predicted_score).to eq(0)
    end
  end
end
