require 'rails_helper'

RSpec.describe "years/new", type: :view do
  before(:each) do
    assign(:year, Year.new())
  end

  it "renders new year form" do
    render

    assert_select "form[action=?][method=?]", years_path, "post" do
    end
  end
end
