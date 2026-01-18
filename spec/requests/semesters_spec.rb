# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Semesters', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /semesters' do
    it 'renders index' do
      get semesters_path
      expect(response).to have_http_status(:ok)
    end

    it 'supports search' do
      create(:semester, name: 'Autumn', user: user)
      create(:semester, name: 'Spring', user: user)

      get semesters_path, params: { search: 'aut' }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Autumn')
      expect(response.body).not_to include('Spring')
    end
  end

  describe 'GET /semesters/:id' do
    it 'renders show' do
      semester = create(:semester, user: user)
      get semester_path(semester)
      expect(response).to have_http_status(:ok)
    end

    it 'supports cumulative param' do
      semester = create(:semester, user: user)
      get semester_path(semester), params: { cumulative: 'false' }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /semesters/new' do
    it 'renders new' do
      get new_semester_path
      expect(response).to have_http_status(:ok)
    end

    it 'prefills year_id when provided' do
      year = create(:year, user: user)
      get new_semester_path, params: { year_id: year.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /semesters/:id/edit' do
    it 'renders edit' do
      semester = create(:semester, user: user)
      get edit_semester_path(semester)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /semesters' do
    it 'creates a semester and redirects' do
      year = create(:year, user: user)
      expect {
        post semesters_path, params: { semester: { name: 'New semester', year_id: year.id } }
      }.to change(Semester, :count).by(1)

      expect(response).to redirect_to(semester_path(Semester.last))
      follow_redirect!
      expect(response.body).to include('Semester was successfully created.')
    end

    it 'renders new on validation failure' do
      year = create(:year, user: user)

      # Trigger the custom validation (MAX_SEMESTERS_PER_YEAR)
      create_list(:semester, Semester::MAX_SEMESTERS_PER_YEAR, user: user, year: year)

      expect {
        post semesters_path, params: { semester: { name: 'Extra semester', year_id: year.id } }
      }.not_to change(Semester, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /semesters/:id' do
    it 'updates and redirects' do
      semester = create(:semester, user: user)
      patch semester_path(semester), params: { semester: { name: 'Updated' } }

      expect(response).to redirect_to(semester_path(semester))
      follow_redirect!
      expect(response.body).to include('Semester was successfully updated.')
    end

    it 'renders edit on validation failure' do
      semester = create(:semester, user: user)

      # Missing required year_id should fail validation and render :edit
      patch semester_path(semester), params: { semester: { year_id: nil } }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /semesters/:id' do
    it 'destroys and redirects' do
      semester = create(:semester, user: user)

      expect {
        delete semester_path(semester)
      }.to change(Semester, :count).by(-1)

      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to(semesters_path)
    end
  end

  describe 'GET /semesters/share/:share_token' do
    it 'renders share page for token' do
      semester = create(:semester, user: user)
      get share_semester_path(semester.share_token)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /semesters/import_form/:share_token' do
    it 'renders import form' do
      semester = create(:semester, user: user)
      get import_form_semester_path(semester.share_token)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /semesters/import/:share_token' do
    it 'imports into an existing year' do
      shared = create(:semester) # different user
      target_year = create(:year, user: user)

      expect {
        post import_semester_path(shared.share_token), params: { year_id: target_year.id }
      }.to change(Semester, :count).by(1)

      expect(response).to redirect_to(semester_path(Semester.last))
      follow_redirect!
      expect(response.body).to include('Semester imported!')
    end

    it 'imports into a new year when year_id is new' do
      shared = create(:semester)

      expect {
        post import_semester_path(shared.share_token), params: { year_id: 'new', new_year_name: 'Imported Year' }
      }.to change(Semester, :count).by(1)
        .and change(Year, :count).by(1)

      expect(response).to redirect_to(semester_path(Semester.last))
    end
  end

  describe 'POST /import_redirect' do
    it 'redirects to import form when token is present' do
      semester = create(:semester)
      post import_redirect_semester_path, params: { share_token: semester.share_token }
      expect(response).to redirect_to(import_form_semester_path(semester.share_token))
    end

    it 'redirects to new semester when token is missing' do
      post import_redirect_semester_path
      expect(response).to redirect_to(new_semester_path)
    end
  end
end
