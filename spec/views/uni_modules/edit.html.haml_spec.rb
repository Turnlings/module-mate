require 'rails_helper'

RSpec.describe "uni_modules/edit", type: :view do
  let(:uni_module) {
    UniModule.create!(
      code: "MyString",
      name: "MyString"
    )
  }

  before(:each) do
    assign(:uni_module, uni_module)
  end

  it "renders the edit uni_module form" do
    render

    assert_select "form[action=?][method=?]", uni_module_path(uni_module), "post" do

      assert_select "input[name=?]", "uni_module[code]"

      assert_select "input[name=?]", "uni_module[name]"
    end
  end
end
