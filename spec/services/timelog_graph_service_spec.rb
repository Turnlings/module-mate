require 'rails_helper'

RSpec.describe TimelogGraphService do
  describe '.date_of' do
    it 'returns nil for "all"' do
      expect(described_class.date_of('all')).to be_nil
    end

    it 'returns a Date for known ranges' do
      expect(described_class.date_of('1_week')).to be_a(Date)
      expect(described_class.date_of('1_month')).to be_a(Date)
      expect(described_class.date_of('3_months')).to be_a(Date)
      expect(described_class.date_of('6_months')).to be_a(Date)
    end
  end

  describe 'private helpers' do
    let(:service) { described_class.new(double('User'), double('Scope')) }

    it 'computes cumulative sums' do
      data = { Date.new(2020, 1, 1) => 1, Date.new(2020, 1, 2) => 2, Date.new(2020, 1, 3) => 3 }
      expect(service.send(:cumulative_sum, data)).to eq({ Date.new(2020, 1, 1) => 1,
                                                         Date.new(2020, 1, 2) => 3,
                                                         Date.new(2020, 1, 3) => 6 })
    end

    it 'trims to active range keeping middle zeros' do
      d1 = Date.new(2020, 1, 1)
      d2 = Date.new(2020, 1, 2)
      d3 = Date.new(2020, 1, 3)
      d4 = Date.new(2020, 1, 4)

      data = { d1 => 0, d2 => 2, d3 => 0, d4 => 3 }
      trimmed = service.send(:trim_to_active_range, data)

      expect(trimmed.keys).to contain_exactly(d2, d3, d4)
      expect(trimmed[d2]).to eq(2)
      expect(trimmed[d3]).to eq(0)
      expect(trimmed[d4]).to eq(3)
    end

    it 'builds grouped data hash' do
      d = Date.new(2020, 1, 1)
      results = { [1, d] => 10, [2, d] => 5 }
      grouped = service.send(:build_grouped_data_hash, results)

      expect(grouped[1][d]).to eq(10)
      expect(grouped[2][d]).to eq(5)
    end

    it 'builds chart data from modules and timelog data' do
      mod = double('UniModule', id: 1, name: 'Mod A', chart_color: '#abc')
      modules = [mod]
      d = Date.new(2020, 1, 1)
      timelog_data = { 1 => { d => 4 } }

      result = service.send(:build_chart_data, modules, timelog_data)

      expect(result).to be_an(Array)
      expect(result.first[:name]).to eq('Mod A')
      expect(result.first[:data]).to be_a(Hash)
      expect(result.first[:color]).to eq('#abc')
    end
  end
end
