# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Exams', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /uni_modules/:uni_module_id/exams' do
    it 'renders index' do
      uni_module = create(:uni_module, user: user)
      get uni_module_exams_path(uni_module)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /uni_modules/:uni_module_id/exams/:id' do
    it 'renders show' do
      exam = create(:exam, user: user)
      get uni_module_exam_path(exam.uni_module, exam)
      expect(response).to have_http_status(:ok)
    end

    it 'responds with JSON when requested' do
      exam = create(:exam, user: user)
      get uni_module_exam_path(exam.uni_module, exam, format: :json)
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')
    end
  end

  describe 'GET /uni_modules/:uni_module_id/exams/new' do
    it 'renders new' do
      uni_module = create(:uni_module, user: user)
      get new_uni_module_exam_path(uni_module)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /uni_modules/:uni_module_id/exams/:id/edit' do
    it 'renders edit' do
      exam = create(:exam, user: user)
      get edit_uni_module_exam_path(exam.uni_module, exam)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /uni_modules/:uni_module_id/exams' do
    it 'creates an exam and redirects' do
      uni_module = create(:uni_module, user: user)

      expect do
        post uni_module_exams_path(uni_module),
             params: { exam: { name: 'Midterm', weight: 30, due: 1.week.from_now, completed: false } }
      end.to change(Exam, :count).by(1)

      expect(response).to redirect_to(uni_module_exam_path(uni_module, Exam.last))
      follow_redirect!
      expect(response.body).to include('Exam was successfully created.')
    end

    it 'renders new on validation failure' do
      uni_module = create(:uni_module, user: user)

      # Trigger the custom validation (MAX_EXAMS_PER_MODULE)
      create_list(:exam, Exam::MAX_EXAMS_PER_MODULE, uni_module: uni_module)

      expect do
        post uni_module_exams_path(uni_module), params: { exam: { name: 'Extra Exam', weight: 10 } }
      end.not_to change(Exam, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe 'PATCH /uni_modules/:uni_module_id/exams/:id' do
    it 'updates and redirects' do
      exam = create(:exam, user: user, name: 'Old')

      patch uni_module_exam_path(exam.uni_module, exam), params: { exam: { name: 'Updated Exam' } }

      expect(response).to redirect_to(uni_module_exam_path(exam.uni_module, exam))
      follow_redirect!
      expect(response.body).to include('Exam was successfully updated.')
    end

    it 'does not allow changing uni_module_id via params' do
      exam = create(:exam, user: user)
      other_module = create(:uni_module, user: user)

      patch uni_module_exam_path(exam.uni_module, exam), params: { exam: { uni_module_id: other_module.id } }

      expect(response).to redirect_to(uni_module_exam_path(exam.uni_module, exam))
      expect(exam.reload.uni_module).to eq(exam.uni_module)
    end

    it 'allows blank name (current behavior)' do
      exam = create(:exam, user: user)

      patch uni_module_exam_path(exam.uni_module, exam), params: { exam: { name: '' } }

      expect(response).to redirect_to(uni_module_exam_path(exam.uni_module, exam))
    end
  end

  describe 'DELETE /uni_modules/:uni_module_id/exams/:id' do
    it 'destroys and redirects' do
      exam = create(:exam, user: user)

      expect do
        delete uni_module_exam_path(exam.uni_module, exam)
      end.to change(Exam, :count).by(-1)

      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to(uni_module_path(exam.uni_module))
      expect(flash[:notice]).to eq('Exam was successfully destroyed.')
    end
  end

  describe 'PATCH /uni_modules/:uni_module_id/exams/:id/mark_completed' do
    it 'marks the exam completed and redirects with notice' do
      exam = create(:exam, user: user, completed: false)

      patch mark_completed_uni_module_exam_path(exam.uni_module, exam)

      expect(response).to redirect_to(uni_module_exam_path(exam.uni_module, exam))
      expect(exam.reload.completed).to be(true)
      expect(flash[:notice]).to eq('Exam marked as completed.')
    end
  end

  describe 'GET /upcoming_assessments' do
    it 'renders upcoming assessments' do
      get all_upcoming_assessments_path
      expect(response).to have_http_status(:ok)
    end
  end
end
