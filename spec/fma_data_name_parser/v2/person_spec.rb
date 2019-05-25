require 'spec_helper'

describe FmaDataNameParser::V2::Person do
  describe '#is_a_team?' do
    it 'returns false' do
      expect(described_class.new({}).is_a_team?).to eq(false)
    end
  end
end
