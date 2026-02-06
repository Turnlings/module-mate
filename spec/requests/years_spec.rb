# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Years', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /years/:id' do
    it 'renders show' do
      year = create(:year, user: user)
      get year_path(year)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /years/new' do
    it 'renders new' do
      get new_year_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /years/:id/edit' do
    it 'renders edit' do
      year = create(:year, user: user)
      get edit_year_path(year)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /years' do
    it 'creates a year and redirects' do
      expect do
        post years_path, params: { year: { name: 'New Year', weighting: 100 } }
      end.to change(Year, :count).by(1)

      expect(response).to redirect_to(year_path(Year.last))
      follow_redirect!
      expect(response.body).to include('Year was successfully created.')
    end

    it 'renders new on validation failure' do
      # Trigger the custom validation (MAX_YEARS_PER_USER)
      create_list(:year, Year::MAX_YEARS_PER_USER, user: user)

      expect do
        post years_path, params: { year: { name: 'Extra Year', weighting: 10 } }
      end.not_to change(Year, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe 'PATCH /years/:id' do
    it 'updates and redirects' do
      year = create(:year, user: user)
      patch year_path(year), params: { year: { name: 'Updated Year', weighting: 50 } }

      expect(response).to redirect_to(year_path(year))
      follow_redirect!
      expect(response.body).to include('Year was successfully updated.')
    end

    it 'does not allow changing the user via params' do
      year = create(:year, user: user)
      other_user = create(:user)

      patch year_path(year), params: { year: { user_id: other_user.id } }

      expect(response).to redirect_to(year_path(year))
      expect(year.reload.user).to eq(user)
    end
  end

  describe 'DELETE /years/:id' do
    it 'destroys and redirects' do
      year = create(:year, user: user)

      expect do
        delete year_path(year)
      end.to change(Year, :count).by(-1)

      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Year was successfully deleted.')
    end
  end
end
