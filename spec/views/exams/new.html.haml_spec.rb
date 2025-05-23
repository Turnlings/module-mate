require 'rails_helper'

RSpec.describe "exams/new", type: :view do
  before(:each) do
    assign(:exam, Exam.new(
      weight: "9.99",
      name: "MyString",
      score: "9.99"
    ))
  end

  it "renders new exam form" do
    render

    assert_select "form[action=?][method=?]", exams_path, "post" do

      assert_select "input[name=?]", "exam[weight]"

      assert_select "input[name=?]", "exam[name]"

      assert_select "input[name=?]", "exam[score]"
    end
  end
end
