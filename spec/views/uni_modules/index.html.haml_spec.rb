require 'rails_helper'

RSpec.describe "uni_modules/index", type: :view do
  before(:each) do
    assign(:uni_modules, [
      UniModule.create!(
        code: "Code",
        name: "Name"
      ),
      UniModule.create!(
        code: "Code",
        name: "Name"
      )
    ])
  end

  it "renders a list of uni_modules" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Code".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
  end
end
