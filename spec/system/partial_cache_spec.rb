require 'rails_helper'

RSpec.describe 'Partial caching', type: :system do
  let(:user) { create(:user) }

  context 'when you update an exam result' do
    it 'bubbles up to updating the year cache' do
      login_as user

      exam = create(:exam, user: user)

      # Check year is set up and cache it
      visit root_path
      expect(page).to have_no_content '50%'
      expect(page).to have_content '0%'

      # Set a result
      visit uni_module_exam_path(exam.uni_module, exam)
      find("a[title='Edit #{exam.name} Score']").click

      fill_in 'exam_result_score', with: 50
      click_on 'Save'

      # Chek the year cards have updated
      visit root_path
      expect(page).to have_content '50%'
    end
  end
end
