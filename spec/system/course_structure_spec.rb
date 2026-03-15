require 'rails_helper'

RSpec.describe 'Course structure', type: :system do
  let(:user) { create(:user) }

  context 'when creating year-semester-module setup' do
    before do
      login_as user

      visit new_year_path
      fill_in 'Name', with: 'First year'
      fill_in 'Weighting', with: 100
      click_on 'Save'

      find("a[title='Add New Semester']").click
      select 'First year', from: 'Year'
      fill_in 'Name', with: 'First semester'
      click_on 'Save'

      find("a[title='Add New Module']").click
      fill_in 'Code', with: 'MM101'
      fill_in 'Name', with: 'Intro to ModuleMate.app'
      fill_in 'Credits', with: 10
      click_on 'Save'
    end

    it 'everything is successfully created' do
      expect(page).to have_content 'Intro to ModuleMate.app'
    end
  end
end
