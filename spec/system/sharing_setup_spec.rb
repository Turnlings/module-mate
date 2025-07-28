require 'rails_helper'

RSpec.describe 'Sharing setup', type: :system do
  let(:user) { create(:user) }

  context 'when you click the share button on semester' do
    it 'copies a shareable link to the semester' do
      login_as user
      
      semester = create(:semester, user: user)

      visit semester_path(semester)

      expect(page).to have_selector('button[title="Copy share link"]')
      find('button[title="Copy share link"]').click

      expect(page).to have_content 'Copied!'
    end
  end

  context 'when you follow the given link' do
    it 'lets you import the semester to a new year' do
      login_as user

      year = create(:year, user: user)
      semester = create(:semester, year: year)

      visit share_semester_path(semester.share_token)

      click_on 'Import this Semester to My Account'

      select 'Create New Year...', from: 'year-select'

      click_on 'Import'

      visit year_path(year)

      expect(page).to have_content semester.name
    end
  end
end