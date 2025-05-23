require 'rails_helper'

RSpec.describe "exams/show", type: :view do
  before(:each) do
    assign(:exam, Exam.create!(
      weight: "9.99",
      name: "Name",
      score: "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/9.99/)
  end
end
