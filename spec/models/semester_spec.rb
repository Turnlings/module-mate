require 'rails_helper'

RSpec.describe Semester do
  describe '#progress' do
    let(:user) { create(:user) }
    let(:semester) { create(:semester) }

    context 'when there are no modules' do
      it 'returns 0' do
        expect(semester.progress(user)).to eq(0)
      end
    end

    context 'when half the credits are completed' do
      before do
        exam1 = create(:exam, uni_module: create(:uni_module, semesters: [semester]))
        exam2 = create(:exam, uni_module: create(:uni_module, semesters: [semester]))
        create(:exam, uni_module: exam1.uni_module)
        create(:exam, uni_module: exam2.uni_module)

        create(:exam_result, exam: exam1, user: user, score: 65)
        create(:exam_result, exam: exam2, user: user, score: 66)
      end

      it 'returns 50%' do
        expect(semester.progress(user)).to eq(50)
      end
    end
  end

  describe '#achieved_score' do
    let(:user) { create(:user) }
    let(:semester) { create(:semester) }

    context 'when there are no modules' do
      it 'returns 0' do
        expect(semester.achieved_score(user)).to eq(0)
      end
    end

    context 'when there are modules with achieved scores' do
      before do
        module1 = create(:uni_module, semesters: [semester], credits: 10)
        module2 = create(:uni_module, semesters: [semester], credits: 20)

        exam1 = create(:exam, uni_module: module1, weight: 100)
        exam2 = create(:exam, uni_module: module2, weight: 100)

        create(:exam_result, exam: exam1, user: user, score: 80)
        create(:exam_result, exam: exam2, user: user, score: 90)
      end

      it 'calculates the weighted average achieved score' do
        expected_score = ((10 * 80) + (20 * 90)) / 30.0
        expect(semester.achieved_score(user)).to be_within(0.0001).of(expected_score)
      end
    end

    context 'when final_score is present' do
      let(:semester) { create(:semester, final_score: 85) }

      it 'returns the final_score instead of calculating from modules' do
        expect(semester.achieved_score(user)).to eq(85)
      end
    end

    context 'when some modules have final_score and some do not' do
      before do
        create(:uni_module, semesters: [semester], credits: 10, final_score: 80)
        module2 = create(:uni_module, semesters: [semester], credits: 20)

        exam = create(:exam, uni_module: module2, weight: 100)
        create(:exam_result, exam: exam, user: user, score: 90)
      end

      it 'uses module-level final_score for modules that have it and calculates for others' do
        expected_score = ((10 * 80) + (20 * 90)) / 30.0
        expect(semester.achieved_score(user)).to be_within(0.0001).of(expected_score)
      end
    end
  end
end
