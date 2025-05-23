require 'rails_helper'

RSpec.describe "timelogs/new", type: :view do
  before(:each) do
    assign(:timelog, Timelog.new(
      uni_module: nil,
      minutes: 1,
      description: "MyString"
    ))
  end

  it "renders new timelog form" do
    render

    assert_select "form[action=?][method=?]", timelogs_path, "post" do

      assert_select "input[name=?]", "timelog[uni_module_id]"

      assert_select "input[name=?]", "timelog[minutes]"

      assert_select "input[name=?]", "timelog[description]"
    end
  end
end
