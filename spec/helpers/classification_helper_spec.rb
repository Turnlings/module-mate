# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ClassificationHelper. For example:
#
# describe ClassificationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ClassificationHelper, type: :helper do
  describe '#classification' do
    it 'returns "1st" for scores 70 and above' do
      expect(helper.classification(70)).to eq('1st')
      expect(helper.classification(100)).to eq('1st')
    end

    it 'returns "2:1" for scores between 60 and 70' do
      expect(helper.classification(60)).to eq('2:1')
      expect(helper.classification(69)).to eq('2:1')
    end

    it 'returns "2:2" for scores between 50 and 60' do
      expect(helper.classification(50)).to eq('2:2')
      expect(helper.classification(59)).to eq('2:2')
    end

    it 'returns "3rd" for scores between 40 and 50' do
      expect(helper.classification(40)).to eq('3rd')
      expect(helper.classification(49)).to eq('3rd')
    end

    it 'returns "..." for a score of 0' do
      expect(helper.classification(0)).to eq('...')
    end

    it 'returns "Fail" for scores below 40' do
      expect(helper.classification(2)).to eq('Fail')
      expect(helper.classification(39)).to eq('Fail')
    end
  end
end
