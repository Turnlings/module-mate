require 'rails_helper'

RSpec.describe "uni_modules/show", type: :view do
  before(:each) do
    assign(:uni_module, UniModule.create!(
      code: "Code",
      name: "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/Name/)
  end
end
