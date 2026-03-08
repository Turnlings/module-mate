# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UniModule do
  describe '#achieved_score' do
    let(:user) { create(:user) }
    let(:uni_module) { create(:uni_module, final_score: nil) }

    context 'when there are no exams' do
      it 'returns 0' do
        expect(uni_module.achieved_score(user)).to eq(0)
      end
    end

    context 'when there are exams with results' do
      let!(:exam_first_half) { create(:exam, uni_module: uni_module, weight: 50) }
      let!(:exam_second_half) { create(:exam, uni_module: uni_module, weight: 50) }

      it 'calculates the weighted average score' do
        create(:exam_result, exam: exam_first_half, user: user, score: 80)
        create(:exam_result, exam: exam_second_half, user: user, score: 90)

        expected_score = (80 * 0.5) + (90 * 0.5)
        expect(uni_module.achieved_score(user)).to eq(expected_score)
      end
    end

    context 'when final_score is present' do
      let(:uni_module) { create(:uni_module, final_score: 85) }

      it 'returns the final_score instead of calculating from exams' do
        expect(uni_module.achieved_score(user)).to eq(85)
      end
    end
  end
end
