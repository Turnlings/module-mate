# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ExamResults', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /exam_results/:id/edit' do
    it 'renders edit when the user has no existing result (builds a new one)' do
      exam = create(:exam, user: user)

      get edit_exam_result_path(exam)

      expect(response).to have_http_status(:ok)
    end

    it 'renders edit when the user already has a result (loads existing result)' do
      exam_result = create(:exam_result, user: user, exam: create(:exam, user: user))

      get edit_exam_result_path(exam_result.exam)

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /exam_results' do
    it 'creates an exam result and redirects to uni module with notice' do
      exam = create(:exam, user: user)

      expect do
        post exam_results_path,
             params: { exam_result: { exam_id: exam.id, score: 80 } }
      end.to change(ExamResult, :count).by(1)

      expect(response).to redirect_to(uni_module_path(exam.uni_module))
      expect(flash[:notice]).to eq('Exam result was successfully created.')
    end

    it 'fails to create when required params are missing and redirects with alert' do
      exam = create(:exam, user: user)

      expect do
        post exam_results_path,
             params: { exam_result: { exam_id: exam.id, score: nil } }
      end.not_to change(ExamResult, :count)

      expect(response).to redirect_to(uni_module_path(exam.uni_module))
      expect(flash[:alert]).to eq('Failed to create exam result.')
    end

    it 'does not allow creating a result for another user via user_id param' do
      exam = create(:exam, user: user)
      other_user = create(:user)

      post exam_results_path,
           params: { exam_result: { exam_id: exam.id, score: 70, user_id: other_user.id } }

      expect(ExamResult.last.user).to eq(user)
    end
  end

  describe 'PATCH /exam_results/:id' do
    it 'updates an exam result and redirects with notice' do
      exam_result = create(:exam_result, user: user, exam: create(:exam, user: user), score: 50)

      patch exam_result_path(exam_result),
            params: { exam_result: { score: 90 } }

      expect(response).to redirect_to(uni_module_path(exam_result.exam.uni_module))
      expect(flash[:notice]).to eq('Exam result was successfully updated.')
      expect(exam_result.reload.score.to_f).to eq(90.0)
    end

    it 'removes the exam result when score is blank' do
      exam_result = create(:exam_result, user: user, exam: create(:exam, user: user))

      expect do
        patch exam_result_path(exam_result),
              params: { exam_result: { score: '' } }
      end.to change(ExamResult, :count).by(-1)

      expect(response).to redirect_to(uni_module_path(exam_result.exam.uni_module))
      expect(flash[:notice]).to eq('Exam result was removed.')
    end

    it 'redirects with alert when update fails' do
      exam_result = create(:exam_result, user: user, exam: create(:exam, user: user))

      allow(ExamResult).to receive(:find).with(exam_result.id.to_s).and_return(exam_result)
      allow(exam_result).to receive(:update).and_return(false)

      patch exam_result_path(exam_result),
            params: { exam_result: { score: 42 } }

      expect(response).to redirect_to(uni_module_path(exam_result.exam.uni_module))
      expect(flash[:alert]).to eq('Failed to update exam result.')
    end
  end
end
