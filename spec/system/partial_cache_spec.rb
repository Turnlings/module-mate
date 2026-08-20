require 'rails_helper'

RSpec.describe 'Partial caching', type: :system do
  let(:user) { create(:user) }

  context 'when you update an exam result' do
    it 'bubbles up to updating the dashboard achieved stat' do
      login_as user

      exam = create(:exam, user: user)

      # Check year is set up and cache it
      visit root_path
      expect(page).to have_selector('.score-section .main .stat', text: '0.0%')

      # Set a result
      visit uni_module_exam_path(exam.uni_module, exam)
      find("a[title='Edit #{exam.name} Score']").click

      fill_in 'exam_result_score', with: 55
      click_on 'Save'

      # Check the main dashboard achieved stat has updated
      visit root_path
      expected_score = format('%.1f%%', user.reload.achieved_score)
      expect(page).to have_selector('.score-section .main .stat', text: expected_score)
    end

    it 'bubbles up to updating the years partial cache' do
      login_as user

      exam = create(:exam, user: user)

      visit root_path
      within('#years') do
        expect(page).to have_selector('.actual', text: '0%')
      end

      visit uni_module_exam_path(exam.uni_module, exam)
      find("a[title='Edit #{exam.name} Score']").click

      fill_in 'exam_result_score', with: 55
      click_on 'Save'

      visit root_path
      expected_year_score = format('%.0f%%', user.reload.years.first.achieved_score(user))

      within('#years') do
        expect(page).to have_selector('.actual', text: expected_year_score)
      end
    end
  end
end
