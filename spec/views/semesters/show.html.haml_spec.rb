require 'rails_helper'

RSpec.describe "semesters/show", type: :view do
  before(:each) do
    assign(:semester, Semester.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
