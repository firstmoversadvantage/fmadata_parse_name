require 'spec_helper'

describe FmadataParseName::V1::Client do
  subject { described_class.new('c104048a-1f32-467c-9022-4b90d8893f85') }

  describe '#parse' do
    it 'raises an exception if token was never given' do
      expect {
        described_class.new(nil).parse('first movers advantage')
      }.to raise_error('No authentication token given')
    end

    it 'raises an exception if an invalid token was given', :vcr do
      expect {
        described_class.new('abc').parse('first movers advantage')
      }.to raise_error(RestClient::Unauthorized, '401 Unauthorized')
    end

    describe 'with a single name' do
      it 'returns an array with a single Person object', :vcr do
        response = subject.parse('mr. tyler kenneth vannurden')
        expect(response.people).to be_a(Array)
        expect(response.people.count).to eq(1)
        expect(response.people.first).to have_attributes(
          salutations: 'Mr',
          given_name: 'Tyler',
          secondary_name: 'Kenneth',
          surname: 'Vannurden'
        )
      end

      it 'returns an empty array for the :organizations key', :vcr do
        response = subject.parse('tyler kenneth vannurden')
        expect(response.organizations).to be_a(Array)
        expect(response.organizations.empty?).to be true
      end

      it 'assigns nil values for attributes that are empty', :vcr do
        response = subject.parse('tyler vannurden')
        expect(response.people.first).to have_attributes(
          secondary_name: nil,
          salutations: nil,
          credentials: nil,
          prefixes: nil,
          suffixes: nil,
          alternate_name: nil
        )
      end
    end

    describe 'with an organization' do
      it 'returns an array with an Organization object if an organization is entered', :vcr do
        response = subject.parse('first movers advantage, llc')
        expect(response.organizations.count).to eq(1)

        expect(response.organizations[0]).to have_attributes(
          name: 'First Movers Advantage, LLC',
        )
      end

      it 'returns an empty array for the :people key', :vcr do
        response = subject.parse('first movers advantage, llc')
        expect(response.people).to be_a(Array)
        expect(response.people.empty?).to be true
      end
    end
  end
end
