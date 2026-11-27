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

  describe '#average_time_per_day' do
    let(:user) { create(:user) }
    let(:uni_module) { create(:uni_module) }

    context 'when there are no timelogs' do
      it 'returns nil' do
        expect(uni_module.average_time_per_day).to be_nil
      end
    end

    context 'when there are timelogs' do
      before do
        create(:timelog, user: user, uni_module: uni_module, date: 2.days.ago, minutes: 60)
        create(:timelog, user: user, uni_module: uni_module, date: 1.day.ago, minutes: 90)
      end

      it 'calculates the average time per day' do
        total_minutes = 60 + 90 # 150 minutes
        days_count = 2
        expected_average = total_minutes / days_count.to_f

        expect(uni_module.average_time_per_day).to eq(expected_average)
      end
    end
  end
end
