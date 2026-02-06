# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExamResult do
  let(:user) { create(:user) }

  it 'touches the exam when updated' do
    exam = create(:exam, user: user)
    exam_result = create(:exam_result, exam: exam, user: user)

    old_timestamp = exam.updated_at
    # rubocop:disable Rails/SkipsModelValidations
    exam_result.touch
    # rubocop:enable Rails/SkipsModelValidations
    expect(exam.reload.updated_at).to be > old_timestamp
  end
end
