require 'rails_helper'

RSpec.describe "semesters/index", type: :view do
  before(:each) do
    assign(:semesters, [
      Semester.create!(),
      Semester.create!()
    ])
  end

  it "renders a list of semesters" do
    render
    cell_selector = 'div>p'
  end
end
