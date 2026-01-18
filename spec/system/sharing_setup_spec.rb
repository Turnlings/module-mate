require 'rails_helper'

RSpec.describe 'Sharing setup' do
  let(:user) { create(:user) }

  context 'when you click the share button on semester' do
    it 'copies a shareable link to the semester' do
      login_as user

      semester = create(:semester, user: user)

      visit semester_path(semester)

      expect(page).to have_css('a[title="Share Template"]')
      find('a[title="Share Template"]').click

      expect(page).to have_css('button[title="Copy Link"]')
      find('button[title="Copy Link"]').click

      expect(page).to have_content 'Copied!'
    end
  end

  context 'when you follow the given link' do
    it 'lets you import the semester to a new year' do
      login_as user

      year = create(:year, user: user)
      semester = create(:semester, year: year)

      visit import_form_semester_path(semester.share_token)

      select 'Create New Year...', from: 'year-select'

      accept_alert do
        click_on 'Import'
      end

      expect(page).to have_content semester.name
    end
  end

  it 'lets you import with the share token' do
    login_as user
    year = create(:year, user: user)
    semester = create(:semester, year: year)

    visit new_semester_path

    fill_in 'share_token', with: semester.share_token

    click_on 'Import'

    select 'Create New Year...', from: 'year-select'

    accept_alert do
      click_on 'Import'
    end

    expect(page).to have_content semester.name
  end
end
