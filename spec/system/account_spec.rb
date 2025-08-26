require 'rails_helper'

RSpec.describe 'Account', type: :system do
  let(:user) { create(:user) }

  context 'registration' do
    before(:each) do
      visit new_user_registration_path
    end

    it 'signs up with valid details' do
      fill_in 'Email', with: "test@account.com"
      fill_in 'Password', with: "Test_Password123"
      fill_in 'Password confirmation', with: "Test_Password123"

      click_on 'Sign up'

      expect(page).to have_content 'Dashboard'
    end

    it 'errors if an invalid email is entered' do
      fill_in 'Email', with: "notanemail"
      fill_in 'Password', with: "Test_Password123"
      fill_in 'Password confirmation', with: "Test_Password123"

      click_on 'Sign up'

      expect(page).not_to have_content 'Dashboard'
    end

    it 'errors if a password is too short' do
      fill_in 'Email', with: "test@account.com"
      fill_in 'Password', with: "123"
      fill_in 'Password confirmation', with: "123"

      click_on 'Sign up'

      expect(page).to have_content 'Password is too short'
    end

    it 'errors if confirmation does not match password' do
      fill_in 'Email', with: "test@account.com"
      fill_in 'Password', with: "Test_Password123"
      fill_in 'Password confirmation', with: "Test_Password12345"

      click_on 'Sign up'

      expect(page).to have_content 'Password confirmation doesn'
    end
  end

  context 'management' do
    it 'can view account details' do
      login_as user

      visit user_path(user)

      expect(page).to have_content user.email
    end

    it 'can edit account details' do
      login_as user

      visit user_path(user)

      expect(page).to have_content user.email

      visit edit_user_registration_path

      fill_in 'Email', with: "changed@account.com"
      fill_in 'Current password', with: "password"

      click_on 'Update'

      expect(page).to have_content "changed@account.com"
    end

    it 'can delete account' do
      login_as user

      visit edit_user_registration_path

      accept_confirm "Are you sure?" do
        click_on 'Cancel my account'
      end

      visit '/'
      click_on 'Log in'

      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: 'password'

      expect(page).not_to have_content 'Dashboard'
    end
  end
end