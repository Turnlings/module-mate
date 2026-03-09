# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  context '#predicted_score' do
    let(:user) { create(:user) }

    it 'returns 0 if there are no years' do
      expect(user.predicted_score).to eq(0)
    end

    it 'calculates predicted score based on achieved score and progress' do
      create(:year, user: user, final_score: nil, weighting: 50)
      create(:year, user: user, final_score: nil, weighting: 50)

      allow(user).to receive(:achieved_score).and_return(85)
      allow(user).to receive(:progress).and_return(75)

      expected_predicted_score = 85 * 100 / 75
      expect(user.predicted_score).to eq(expected_predicted_score)
    end

    it 'returns 0 when progress is 0' do
      create(:year, user: user, final_score: nil, weighting: 100)

      allow(user).to receive(:achieved_score).and_return(85)
      allow(user).to receive(:progress).and_return(0)

      expect(user.predicted_score).to eq(0)
    end
  end
end
