# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Timelogs' do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /uni_modules/:uni_module_id/timelogs' do
    it 'renders index' do
      uni_module = create(:uni_module, user: user)
      get uni_module_timelogs_path(uni_module)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /uni_modules/:uni_module_id/timelogs/new' do
    it 'renders new' do
      uni_module = create(:uni_module, user: user)
      get new_uni_module_timelog_path(uni_module)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /uni_modules/:uni_module_id/timelogs' do
    it 'creates a timelog and redirects to the module' do
      uni_module = create(:uni_module, user: user)

      expect do
        post uni_module_timelogs_path(uni_module),
             params: { timelog: { date: Date.current, minutes: 45, description: 'Study' } }
      end.to change(Timelog, :count).by(1)

      expect(response).to redirect_to(uni_module_path(uni_module))
      expect(flash[:notice]).to eq('Timelog was successfully created.')
    end

    it 'creates even with missing minutes (no validations present)' do
      uni_module = create(:uni_module, user: user)

      expect do
        post uni_module_timelogs_path(uni_module),
             params: { timelog: { date: Date.current, minutes: nil, description: 'Study' } }
      end.to change(Timelog, :count).by(1)

      expect(response).to redirect_to(uni_module_path(uni_module))
    end
  end

  describe 'GET /uni_modules/:uni_module_id/timelogs/:id' do
    it 'renders show' do
      timelog = create(:timelog, user: user)
      get uni_module_timelog_path(timelog.uni_module, timelog)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /uni_modules/:uni_module_id/timelogs/:id/edit' do
    it 'renders edit' do
      timelog = create(:timelog, user: user)
      get edit_uni_module_timelog_path(timelog.uni_module, timelog)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PATCH /uni_modules/:uni_module_id/timelogs/:id' do
    it 'updates and redirects to the module' do
      timelog = create(:timelog, user: user)

      patch uni_module_timelog_path(timelog.uni_module, timelog),
            params: { timelog: { minutes: 60, description: 'Updated' } }

      expect(response).to redirect_to(uni_module_path(timelog.uni_module))
      expect(flash[:notice]).to eq('Timelog was successfully updated.')
    end
  end

  describe 'DELETE /uni_modules/:uni_module_id/timelogs/:id' do
    it 'destroys and redirects to the module' do
      timelog = create(:timelog, user: user)

      expect do
        delete uni_module_timelog_path(timelog.uni_module, timelog)
      end.to change(Timelog, :count).by(-1)

      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to(uni_module_path(timelog.uni_module))
      expect(flash[:notice]).to eq('Timelog was successfully deleted.')
    end
  end
end
