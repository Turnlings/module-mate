# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Year do
  describe '#achieved_score' do
    let(:user) { create(:user) }
    let(:year) { create(:year, final_score: nil) }

    context 'when there are no semesters' do
      it 'returns 0' do
        expect(year.achieved_score(user)).to eq(0)
      end
    end

    context 'when there are semesters with uni modules and results' do
      it 'calculates the weighted average score across all semesters and modules' do
        semester_light = create(:semester, year: year)
        semester_heavy = create(:semester, year: year)

        module_light = create(:uni_module, semesters: [semester_light], credits: 10)
        module_heavy = create(:uni_module, semesters: [semester_heavy], credits: 20)

        exam_light = create(:exam, uni_module: module_light, weight: 100)
        exam_heavy = create(:exam, uni_module: module_heavy, weight: 100)

        create(:exam_result, exam: exam_light, user: user, score: 80)
        create(:exam_result, exam: exam_heavy, user: user, score: 90)

        expected_score = ((80 * 10.0 / 30.0) + (90 * 20.0 / 30.0))
        expect(year.achieved_score(user)).to be_within(0.0001).of(expected_score)
      end
    end

    context 'when final_score is present' do
      let(:year) { create(:year, final_score: 85) }

      it 'returns the final_score instead of calculating from semesters' do
        expect(year.achieved_score(user)).to eq(85)
      end
    end

    context 'when some semesters have final_score and some do not' do
      it 'uses semester-level final_score for semesters that have it and calculates for others' do
        semester_with_final = create(:semester, year: year, final_score: 80)
        semester_without_final = create(:semester, year: year, final_score: nil)

        uni_module = create(:uni_module, semesters: [semester_without_final], credits: 20)
        exam = create(:exam, uni_module: uni_module, weight: 100)
        create(:exam_result, exam: exam, user: user, score: 90)

        final_credits = semester_with_final.credits.to_f
        calculated_credits = semester_without_final.credits.to_f
        total_credits = final_credits + calculated_credits

        expected_score = (
          (80 * final_credits) +
          (90 * calculated_credits)
        ) / total_credits

        expect(year.achieved_score(user)).to be_within(0.0001).of(expected_score)
      end
    end
  end
end
