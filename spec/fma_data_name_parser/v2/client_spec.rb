require 'spec_helper'

describe FmaDataNameParser::V2::Client do
  subject { described_class.new('66039622-9040-4964-bfe2-8ce4d1176724') }

  describe '#parse' do
    it 'raises an exception if token was never given' do
      expect {
        described_class.new(nil).parse('first movers advantage')
      }.to raise_error('No authentication token given')
    end

    it 'raises an exception if an invalid token was given' do
      VCR.use_cassette("v2/invalid_token") do
        expect {
          described_class.new('abc').parse('first movers advantage')
        }.to raise_error(RestClient::Unauthorized, '401 Unauthorized')
      end
    end

    it 'returns an array with a Person object if a single name is entered' do
      VCR.use_cassette("v2/single_name") do
        response = subject.parse('mr. tyler kenneth vannurden, President')
        expect(response[:people]).to be_a(Array)
        expect(response[:people].count).to eq(1)
        expect(response[:people].first).to have_attributes(
          salutations: 'Mr',
          given_name: 'Tyler',
          secondary_name: 'Kenneth',
          surname: 'Vannurden',
          job_titles: 'President'
        )
      end
    end

    it 'returns an array with two Person objects if two names are entered' do
      VCR.use_cassette("v2/two_names") do
        response = subject.parse('Tyler and Nolan Vannurden')
        expect(response[:people].count).to eq(2)

        expect(response[:people][0]).to have_attributes(
          given_name: 'Tyler',
          surname: 'Vannurden',
        )

        expect(response[:people][1]).to have_attributes(
          given_name: 'Nolan',
          surname: 'Vannurden',
        )
      end
    end

    it 'returns an array with an Organization object if an organization is entered' do
      VCR.use_cassette("v2/single_organization") do
        response = subject.parse('first movers advantage')
        expect(response[:organizations].count).to eq(1)

        expect(response[:organizations][0]).to have_attributes(
          name: 'First Movers Advantage',
        )
      end
    end

    it 'returns an array with a Person object and Organization object if both are entered' do
      VCR.use_cassette("v2/name_and_organization") do
        response = subject.parse('tyler vannurden, first movers advantage')
        expect(response[:people].count).to eq(1)
        expect(response[:organizations].count).to eq(1)

        expect(response[:people].first).to have_attributes(
          given_name: 'Tyler',
          surname: 'Vannurden',
        )

        expect(response[:organizations][0]).to have_attributes(
          name: 'First Movers Advantage',
        )
      end
    end
  end
end
