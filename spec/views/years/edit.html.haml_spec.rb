require 'rails_helper'

RSpec.describe "years/edit", type: :view do
  let(:year) {
    Year.create!()
  }

  before(:each) do
    assign(:year, year)
  end

  it "renders the edit year form" do
    render

    assert_select "form[action=?][method=?]", year_path(year), "post" do
    end
  end
end
