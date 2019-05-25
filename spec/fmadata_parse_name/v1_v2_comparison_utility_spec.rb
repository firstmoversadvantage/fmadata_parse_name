require 'spec_helper'

describe FmadataParseName::V1V2ComparisonUtility do
  let(:v1_client) do
    FmadataParseName::V1::Client.new('c104048a-1f32-467c-9022-4b90d8893f85')
  end

  let(:v2_client) do
    FmadataParseName::V2::Client.new('66039622-9040-4964-bfe2-8ce4d1176724')
  end

  describe 'when v1 and v2 return the same results' do
    context 'for a single name' do
      it 'returns true', :vcr do
        name = 'tyler vannurden'
        v1_result = v1_client.parse(name)
        v2_result = v2_client.parse(name)

        comparison = described_class.new(input: name, v1: v1_result, v2: v2_result)

        expect(comparison.compare).to be true
      end
    end

    context 'for an organization' do
      it 'returns true', :vcr do

      end
    end

    context 'for an ambiguous input that failed for both' do
      it 'returns true', :vcr do

      end
    end
  end
end
