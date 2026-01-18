require 'rails_helper'

RSpec.describe Semester, type: :model do
  describe '#average_score' do
    let(:user) { create(:user) }
    let(:semester) { create(:semester) }

    context 'when there are no exam results' do
      it 'returns 0' do
        expect(semester.average_score(user)).to eq(0)
      end
    end

    context 'when exam results exist' do
      before do
        exam1 = create(:exam, uni_module: create(:uni_module, semesters: [semester]))
        exam2 = create(:exam, uni_module: create(:uni_module, semesters: [semester]))

        create(:exam_result, exam: exam1, user: user, score: 60)
        create(:exam_result, exam: exam2, user: user, score: 80)
      end

      it 'returns the average score' do
        expect(semester.average_score(user)).to eq(70)
      end
    end

    context 'when the average is fractional' do
      before do
        exam1 = create(:exam, uni_module: create(:uni_module, semesters: [semester]))
        exam2 = create(:exam, uni_module: create(:uni_module, semesters: [semester]))

        create(:exam_result, exam: exam1, user: user, score: 65)
        create(:exam_result, exam: exam2, user: user, score: 66)
      end

      it 'returns a float average' do
        expect(semester.average_score(user)).to eq(65.5)
      end
    end
  end

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
end
