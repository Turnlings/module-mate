require 'rails_helper'

RSpec.describe 'Module targets', type: :system do
  let(:user) { create(:user) }

  context 'when you set a target' do
    let(:uni_module) { create(:uni_module, user: user) }

    before do
      create(:exam, uni_module: uni_module)

      login_as user

      visit edit_uni_module_path(uni_module)

      within('#target-form') do
        fill_in 'uni_module_target_score', with: 43
        click_on 'Save'
      end
    end

    it 'shows up next the the exams' do
      visit uni_module_path(uni_module)
      expect(page).to have_content '43'
    end
  end

  context 'when you overwrite a target' do
    let(:uni_module) { create(:uni_module, user: user) }

    before do
      create(:exam, uni_module: uni_module)

      login_as user

      visit edit_uni_module_path(uni_module)

      within('#target-form') do
        fill_in 'uni_module_target_score', with: 43
        click_on 'Save'
      end

      # To ensure first score is cached
      visit uni_module_path(uni_module)

      visit edit_uni_module_path(uni_module)

      within('#target-form') do
        fill_in 'uni_module_target_score', with: 72
        click_on 'Save'
      end
    end

    it 'recalculates the required score' do
      visit uni_module_path(uni_module)
      expect(page).to have_content '72'
    end
  end
end
