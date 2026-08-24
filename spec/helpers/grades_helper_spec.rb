# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the GradesHelper. For example:
#
# describe GradesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe GradesHelper, type: :helper do
  describe '#class_badge' do
    it 'returns "First Class" for scores 70 and above' do
      expect(helper.class_badge(70)).to include('First Class')
      expect(helper.class_badge(100)).to include('First Class')
    end

    it 'returns "Second Class (2:1)" for scores between 60 and 70' do
      expect(helper.class_badge(60)).to include('Second Class (2:1)')
      expect(helper.class_badge(69)).to include('Second Class (2:1)')
    end

    it 'returns "Second Class (2:2)" for scores between 50 and 60' do
      expect(helper.class_badge(50)).to include('Second Class (2:2)')
      expect(helper.class_badge(59)).to include('Second Class (2:2)')
    end

    it 'returns "Third Class" for scores between 40 and 50' do
      expect(helper.class_badge(40)).to include('Third Class')
      expect(helper.class_badge(49)).to include('Third Class')
    end

    it 'returns "Failed" for scores below 40' do
      expect(helper.class_badge(-1)).to include('Failed')
      expect(helper.class_badge(39)).to include('Failed')
    end
  end
end
