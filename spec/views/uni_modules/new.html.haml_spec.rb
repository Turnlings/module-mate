require 'rails_helper'

RSpec.describe "uni_modules/new", type: :view do
  before(:each) do
    assign(:uni_module, UniModule.new(
      code: "MyString",
      name: "MyString"
    ))
  end

  it "renders new uni_module form" do
    render

    assert_select "form[action=?][method=?]", uni_modules_path, "post" do

      assert_select "input[name=?]", "uni_module[code]"

      assert_select "input[name=?]", "uni_module[name]"
    end
  end
end
