require 'rails_helper'

RSpec.describe "timelogs/index", type: :view do
  before(:each) do
    assign(:timelogs, [
      Timelog.create!(
        uni_module: nil,
        minutes: 2,
        description: "Description"
      ),
      Timelog.create!(
        uni_module: nil,
        minutes: 2,
        description: "Description"
      )
    ])
  end

  it "renders a list of timelogs" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Description".to_s), count: 2
  end
end
