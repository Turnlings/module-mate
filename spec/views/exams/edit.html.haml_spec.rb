require 'rails_helper'

RSpec.describe "exams/edit", type: :view do
  let(:exam) {
    Exam.create!(
      weight: "9.99",
      name: "MyString",
      score: "9.99"
    )
  }

  before(:each) do
    assign(:exam, exam)
  end

  it "renders the edit exam form" do
    render

    assert_select "form[action=?][method=?]", exam_path(exam), "post" do

      assert_select "input[name=?]", "exam[weight]"

      assert_select "input[name=?]", "exam[name]"

      assert_select "input[name=?]", "exam[score]"
    end
  end
end
