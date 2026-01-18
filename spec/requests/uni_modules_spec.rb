# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UniModules' do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /uni_modules' do
    it 'renders index' do
      get uni_modules_path
      expect(response).to have_http_status(:ok)
    end

    it 'supports search by code/name' do
      create(:uni_module, user: user, code: 'MAT101', name: 'Maths')
      create(:uni_module, user: user, code: 'COM101', name: 'Computing')

      get uni_modules_path, params: { search: 'mat' }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('MAT101')
      expect(response.body).not_to include('COM101')
    end
  end

  describe 'GET /uni_modules/:id' do
    it 'renders show' do
      uni_module = create(:uni_module, user: user)
      get uni_module_path(uni_module)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /uni_modules/new' do
    it 'renders new' do
      get new_uni_module_path
      expect(response).to have_http_status(:ok)
    end

    it 'accepts semester_id param for prefill' do
      semester = create(:semester, user: user)
      get new_uni_module_path, params: { semester_id: semester.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /uni_modules/:id/edit' do
    it 'renders edit' do
      uni_module = create(:uni_module, user: user)
      get edit_uni_module_path(uni_module)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /uni_modules' do
    it 'creates a uni module and redirects' do
      semester = create(:semester, user: user)

      expect do
        post uni_modules_path,
             params: { uni_module: { code: 'ABC123', name: 'Algorithms', credits: 10, semester_ids: [semester.id] } }
      end.to change(UniModule, :count).by(1)

      expect(response).to redirect_to(uni_module_path(UniModule.last))
      follow_redirect!
      expect(response.body).to include('Uni module was successfully created.')
    end

    it 'renders new on validation failure' do
      semester = create(:semester, user: user)

      # Trigger the custom validation (MAX_MODULES_PER_SEMESTER)
      create_list(:uni_module, UniModule::MAX_MODULES_PER_SEMESTER, user: user, semesters: [semester])

      expect do
        post uni_modules_path,
             params: { uni_module: { code: 'ZZZ999', name: 'Extra', credits: 10, semester_ids: [semester.id] } }
      end.not_to change(UniModule, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe 'PATCH /uni_modules/:id' do
    it 'updates and redirects' do
      uni_module = create(:uni_module, user: user)
      patch uni_module_path(uni_module), params: { uni_module: { name: 'Updated Name' } }

      expect(response).to redirect_to(uni_module_path(uni_module))
      follow_redirect!
      expect(response.body).to include('Uni module was successfully updated.')
    end

    it 'can clear semesters when semester_ids is empty' do
      uni_module = create(:uni_module, user: user)

      patch uni_module_path(uni_module), params: { uni_module: { semester_ids: [] } }

      expect(response).to redirect_to(uni_module_path(uni_module))
      expect(uni_module.reload.semesters).to be_empty
    end
  end

  describe 'DELETE /uni_modules/:id' do
    it 'destroys and redirects' do
      uni_module = create(:uni_module, user: user)

      expect do
        delete uni_module_path(uni_module)
      end.to change(UniModule, :count).by(-1)

      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to(uni_modules_path)
    end
  end

  describe 'PATCH /uni_modules/:id/pin' do
    it 'toggles pinned and redirects with notice' do
      uni_module = create(:uni_module, user: user, pinned: false)

      patch pin_uni_module_path(uni_module)

      expect(response).to redirect_to(uni_module_path(uni_module))
      expect(uni_module.reload.pinned).to be(true)
      expect(flash[:notice]).to eq('Module pin status updated successfully.')
    end
  end
end
