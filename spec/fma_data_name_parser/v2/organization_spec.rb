require 'spec_helper'

describe FmaDataNameParser::V2::Organization do
  describe '#is_a_team?' do
    it 'returns true when the organization contains the word "team"' do
      expect(described_class.new('name' => 'The Old Team').is_a_team?).to eq(true)
      expect(described_class.new('name' => 'team 10').is_a_team?).to eq(true)
    end

    it 'returns false when the organization does not contain the word "team"' do
      expect(described_class.new('name' => 'The Old Teammates').is_a_team?).to eq(false)
      expect(described_class.new('name' => 'teammates 10').is_a_team?).to eq(false)
      expect(described_class.new('name' => '').is_a_team?).to eq(false)
    end
  end
end
