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

        comparison = described_class.new(input: name, v1_result: v1_result, v2_result: v2_result)

        expect(comparison.compare).to be true
      end
    end

    context 'for an organization' do
      it 'returns true', :vcr do
        org_name = 'First Movers Advantage, LLC'
        v1_result = v1_client.parse(org_name)
        v2_result = v2_client.parse(org_name)

        comparison = described_class.new(input: org_name, v1_result: v1_result, v2_result: v2_result)

        expect(comparison.compare).to be true
      end
    end

    context 'for an ambiguous input that failed for both' do
      it 'returns true when junk is passed', :vcr do
        name = 'a b c d e f g h i j k l m n o p'
        v1_result = v1_client.parse(name)
        v2_result = v2_client.parse(name)

        comparison = described_class.new(input: name, v1_result: v1_result, v2_result: v2_result)

        expect(comparison.compare).to be true
      end

      it 'returns true when only a first name is passed', :vcr do
        name = 'tyler'
        v1_result = v1_client.parse(name)
        v2_result = v2_client.parse(name)

        comparison = described_class.new(input: name, v1_result: v1_result, v2_result: v2_result)

        expect(comparison.compare).to be true
      end
    end
  end

  describe 'when v1 and v2 return different results' do
    context 'when v2 returns an organization and v1 fails' do
      it 'returns false and the correct #diff_message', :vcr do
        org_name = 'First Movers Advantage'

        v1_result = v1_client.parse(org_name)
        v2_result = v2_client.parse(org_name)

        comparison = described_class.new(input: org_name, v1_result: v1_result, v2_result: v2_result)

        expect(comparison.compare).to be false
        expect(comparison.diff_message).to eq('v1 success?: false v2 success?: true')
      end
    end

    context 'when v2 returns an organization and v1 returns a name' do
      it 'returns false and the correct #diff_message', :vcr do
        org_name = 'Tyler Roman Catholic'

        v1_result = v1_client.parse(org_name)
        v2_result = v2_client.parse(org_name)

        comparison = described_class.new(input: org_name, v1_result: v1_result, v2_result: v2_result)

        expect(comparison.compare).to be false
        expect(comparison.diff_message).to eq('v1 people count: 1 v2 people count: 0')
      end
    end

    # context 'for an organization' do

    # end

    context 'for a name' do

    end

    context 'when v2 returns two names and v1 returns one' do
      it 'returns false and the correct #diff message', :vcr do
        name = 'Bill and Melinda Gates'

        v1_result = v1_client.parse(name)
        v2_result = v2_client.parse(name)

        comparison = described_class.new(input: name, v1_result: v1_result, v2_result: v2_result)

        expect(comparison.compare).to be false
        expect(comparison.diff_message).to eq('v1 people count: 1 v2 people count: 2')
      end
    end

    context 'when v2 returns a name and an organization and v1 returns a name' do
      it 'returns false and the correct #diff message', :vcr do
        name = 'Mark Zuckerberg, Facebook Inc'

        v1_result = v1_client.parse(name)
        v2_result = v2_client.parse(name)

        comparison = described_class.new(input: name, v1_result: v1_result, v2_result: v2_result)

        expect(comparison.compare).to be false
        expect(comparison.diff_message).to eq('v1 people count: 0 v2 people count: 1')
      end
    end
  end
end
