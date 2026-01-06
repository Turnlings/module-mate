# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Exam, type: :model do
  # The following tests using fixed historical days so that the tests are deterministic and repeatable
  context 'with multiple exams' do
    it 'should return the time remaining to the exam' do
      exam1 = Exam.new
      exam1.due = DateTime.new(2026, 1, 2, 0, 0, 0, 0)
      exam2 = Exam.new
      exam2.due = DateTime.new(2026, 3, 1, 0, 0, 0, 0)
      exam3 = Exam.new
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
    it 'should return the default [0, 0, 0, 0] given an nil input value' do
      exam1 = Exam.new
      exam1.due = DateTime.new(2026, 1, 2, 0, 0, 0, 0)

      result = exam1.time_until_due(nil)

      expect(result).to eq [0, 0, 0, 0]
    end
  end
  context 'with an exam with the due date being nil' do
    it 'should return the default [0,0,0,0] value' do
      exam1 = Exam.new
      result = exam1.time_until_due(DateTime.new(2026, 1, 2, 0, 0, 0, 0))
      expect(result).to eq [0, 0, 0, 0]
    end
  end

end
