require 'rails_helper'

RSpec.describe "semesters/new", type: :view do
  before(:each) do
    assign(:semester, Semester.new())
  end

  it "renders new semester form" do
    render

    assert_select "form[action=?][method=?]", semesters_path, "post" do
    end
  end
end
