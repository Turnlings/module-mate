require 'rails_helper'

RSpec.describe "years/show", type: :view do
  before(:each) do
    assign(:year, Year.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
