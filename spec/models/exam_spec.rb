# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exam do
  # The following tests using fixed historical days so that the tests are deterministic and repeatable
  context 'with multiple exams' do
    it 'returns the time remaining to the exam' do
      exam1 = described_class.new
      exam1.due = DateTime.new(2026, 1, 2, 0, 0, 0, 0)
      exam2 = described_class.new
      exam2.due = DateTime.new(2026, 3, 1, 0, 0, 0, 0)
      exam3 = described_class.new
      exam3.due = DateTime.new(2026, 4, 1, 0, 0, 0, 0)
      result1 = exam1.time_until_due(DateTime.new(2025, 12, 1, 0, 0, 0))
      # Intentionally use a fixed historical "current" date here so that the
      # number of days between 2023-01-01 and the due date 2026-03-01 is
      # deterministic and independent of the actual current date.
      result2 = exam2.time_until_due(DateTime.new(2023, 1, 1, 0, 0, 0))
      result3 = exam3.time_until_due(DateTime.new(2027, 8, 1, 0, 0, 0))
      result4 = exam1.time_until_due(DateTime.new(2026, 1, 1, 16, 30, 51))

      expect(result1).to eq [32, 0, 0, 0]
      expect(result2).to eq [1155, 0, 0, 0]
      expect(result3).to eq [0, 0, 0, 0]
      expect(result4).to eq [0, 7, 29, 9]
    end

    it 'returns the default [0, 0, 0, 0] given an nil input value' do
      exam1 = described_class.new
      exam1.due = DateTime.new(2026, 1, 2, 0, 0, 0, 0)

      result = exam1.time_until_due(nil)

      expect(result).to eq [0, 0, 0, 0]
    end
  end

  context 'with an exam with the due date being nil' do
    it 'returns the default [0,0,0,0] value' do
      exam1 = described_class.new
      result = exam1.time_until_due(DateTime.new(2026, 1, 2, 0, 0, 0, 0))
      expect(result).to eq [0, 0, 0, 0]
    end
  end

  describe '#estimated_score' do
    let(:user) { create(:user) }
    let(:uni_module) { create(:uni_module) }
    let(:exam) { create(:exam, uni_module: uni_module) }

    context 'when the user has no exam result' do
      it 'returns 0' do
        expect(exam.estimated_score(user)).to eq(0)
      end
    end

    context 'when the user has an exam result' do
      it 'returns the score from the exam result' do
        create(:exam_result, exam: exam, user: user, score: 85)
        expect(exam.estimated_score(user)).to eq(85)
      end
    end

    context 'when the user has an exam result with a score of 0' do
      it 'returns 0' do
        create(:exam_result, exam: exam, user: user, score: 0)
        expect(exam.estimated_score(user)).to eq(0)
      end
    end

    context 'when the user has an exam result with a score greater than 100' do
      it 'returns the score from the exam result without capping at 100' do
        create(:exam_result, exam: exam, user: user, score: 120)
        expect(exam.estimated_score(user)).to eq(120)
      end
    end

    context 'when the module has a final score and other exams with results' do
      let(:uni_module) { create(:uni_module, final_score: 80) }
      let!(:exam) { create(:exam, uni_module: uni_module, weight: 50) }
      let!(:other_exam) { create(:exam, uni_module: uni_module, weight: 50) }

      it 'returns the final score if it is present' do
        create(:exam_result, exam: other_exam, user: user, score: 70)
        expect(exam.estimated_score(user)).to eq(90)
      end
    end
  end
end
