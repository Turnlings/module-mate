require 'rails_helper'

RSpec.describe "timelogs/edit", type: :view do
  let(:timelog) {
    Timelog.create!(
      uni_module: nil,
      minutes: 1,
      description: "MyString"
    )
  }

  before(:each) do
    assign(:timelog, timelog)
  end

  it "renders the edit timelog form" do
    render

    assert_select "form[action=?][method=?]", timelog_path(timelog), "post" do

      assert_select "input[name=?]", "timelog[uni_module_id]"

      assert_select "input[name=?]", "timelog[minutes]"

      assert_select "input[name=?]", "timelog[description]"
    end
  end
end
