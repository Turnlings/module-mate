require 'rails_helper'

RSpec.describe "years/index", type: :view do
  before(:each) do
    assign(:years, [
      Year.create!(),
      Year.create!()
    ])
  end

  it "renders a list of years" do
    render
    cell_selector = 'div>p'
  end
end
