require 'rails_helper'

RSpec.describe 'Logging time', type: :system do
  let(:user) { create(:user) }

  context 'when quicklogging time from the homepage' do
    it 'correctly logs minutes if the code matches a module' do
      login_as user

      uni_module = create(:uni_module, user: user)

      visit '/'
      click_on 'Quicklog'

      fill_in 'module_code', with: uni_module.code
      fill_in 'minutes', with: 10

      click_on 'Add Time'

      visit uni_module_path(uni_module)

      page.refresh

      expect(page).to have_content '10'
    end

    it 'informs the user if it cannot match the module code' do
      login_as user

      uni_module = create(:uni_module, user: user)

      visit '/'
      click_on 'Quicklog'

      fill_in 'module_code', with: uni_module.code + '123456'
      fill_in 'minutes', with: 10

      click_on 'Add Time'

      expect(page).to have_content 'Module not found.'
    end

    it 'does not let the user log negative minutes' do
      login_as user

      uni_module = create(:uni_module, user: user)

      visit '/'
      click_on 'Quicklog'

      fill_in 'module_code', with: uni_module.code
      fill_in 'minutes', with: -1

      click_on 'Add Time'

      expect(page).to have_content 'Time logged must be positive.'
    end
  end

  context 'when logging time on the module page' do
    it 'lets the user add a timelog with a description' do
      login_as user

      uni_module = create(:uni_module, user: user)

      visit uni_module_path(uni_module)

      find('a[title="Log time"]').click

      within '#new_timelog' do
        fill_in 'Minutes', with: 28
        fill_in 'Description', with: 'Working on some stuff'
      end

      click_on 'Save'

      expect(page).to have_content '28'
      expect(page).to have_content 'Working on some stuff'
    end
  end
end
