# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Visiting the homepage', type: :system do
  let(:user) { create(:user) }

  it 'shows the welcome text' do
    login_as user
    visit '/'
    expect(page).to have_content 'Dashboard'
  end

  it 'shows year progress' do
    login_as user
    create(:year, user: user, name: 'Year 1', weighting: 25)
    create(:year, user: user, name: 'Year 2', weighting: 75)
    visit '/'
    expect(page).to have_content 'Year 1'
    expect(page).to have_content 'Year 2'
    expect(page).to have_content '25%'
    expect(page).to have_content '75%'
  end

  it 'shows the achieved score' do
    login_as user
    year = create(:year, user: user, name: 'Year 1', weighting: 50)
    semester = create(:semester, year: year, name: 'Semester 1')
    uni_module = create(:uni_module, semester: semester, credits: 30)
    create(:uni_module, semester: semester, credits: 30) # Another module to ensure calculation is correct
    exam = create(:exam, uni_module: uni_module)
    create(:exam_result, user: user, exam: exam, score: 80)
    
    visit '/'
    expect(page).to have_content 'Achieved'
    expect(page).to have_content '40%'
  end
end
