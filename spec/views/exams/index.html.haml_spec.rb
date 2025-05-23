require 'rails_helper'

RSpec.describe "exams/index", type: :view do
  before(:each) do
    assign(:exams, [
      Exam.create!(
        weight: "9.99",
        name: "Name",
        score: "9.99"
      ),
      Exam.create!(
        weight: "9.99",
        name: "Name",
        score: "9.99"
      )
    ])
  end

  it "renders a list of exams" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
  end
end
