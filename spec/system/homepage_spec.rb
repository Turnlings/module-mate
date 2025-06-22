require 'rails_helper'

RSpec.describe 'Visiting the homepage', type: :system do
  let(:user) { create(:user) }

  it 'shows the welcome text' do
    login_as user
    visit '/'
    expect(page).to have_content 'Dashboard'
  end
end