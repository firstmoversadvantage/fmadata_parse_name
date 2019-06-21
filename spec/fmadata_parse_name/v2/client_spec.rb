require 'spec_helper'

describe FmadataParseName::V2::Client do
  subject { described_class.new('used-to-be-valid-token') }

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

    it 'returns a Response object if the parse failed', vcr: vcr_spec_options do
      response = subject.parse('tyler')
      expect(response).to be_a(FmadataParseName::V2::Response)
    end

    describe '#errors' do
      context 'when the parse succeeded' do
        it 'returns an empty hash', vcr: vcr_spec_options do
          response = subject.parse('first movers advantage')
          expect(response.errors).to eq({})
        end
      end

      context 'when the parse failed' do
        it 'returns the error message due to ambiguous input', vcr: vcr_spec_options do
          response = subject.parse('tyler')
          expect(response.errors).to eq(
            {
              "input" => ["could not be distinguished between a name or organization"]
            }
          )
        end

        it 'returns the error message due to given name being same as surname', vcr: vcr_spec_options do
          response = subject.parse('tyler tyler')
          expect(response.errors).to eq(
            { "input" => ["given_name was the same as surname"] }
          )
        end
      end
    end

    context 'with a single name' do
      it 'returns an array with a Person object', vcr: vcr_spec_options do
        response = subject.parse('mr. tyler kenneth vannurden, President')
        expect(response.people).to be_a(Array)
        expect(response.people.count).to eq(1)
        expect(response.people.first).to have_attributes(
          salutations: 'Mr',
          given_name: 'Tyler',
          secondary_name: 'Kenneth',
          surname: 'Vannurden',
          job_titles: 'President'
        )
      end

      it 'returns an empty array for the :organizations key', vcr: vcr_spec_options do
        response = subject.parse('mr. tyler kenneth vannurden, President')
        expect(response.organizations).to be_a(Array)
        expect(response.organizations.empty?).to be true
      end
    end

    context 'with two names' do
      it 'returns an array with two Person objects', vcr: vcr_spec_options do
        response = subject.parse('Tyler and Nolan Vannurden')
        expect(response.people.count).to eq(2)

        expect(response.people[0]).to have_attributes(
          given_name: 'Tyler',
          surname: 'Vannurden',
        )

        expect(response.people[1]).to have_attributes(
          given_name: 'Nolan',
          surname: 'Vannurden',
        )
      end
    end

    context 'with an organization' do
      it 'returns an array with an Organization object', vcr: vcr_spec_options do
        response = subject.parse('first movers advantage')
        expect(response.organizations.count).to eq(1)

        expect(response.organizations.first).to have_attributes(
          name: 'First Movers Advantage',
        )
      end

      it 'returns an empty array for the :people key', vcr: vcr_spec_options do
        response = subject.parse('first movers advantage')
        expect(response.people).to be_a(Array)
        expect(response.people.empty?).to be true
      end
    end

    context 'with a name and an organization' do
      it 'returns an array with a Person object and Organization object', vcr: vcr_spec_options do
        response = subject.parse('tyler vannurden, first movers advantage')
        expect(response.people.count).to eq(1)
        expect(response.organizations.count).to eq(1)

        expect(response.people.first).to have_attributes(
          given_name: 'Tyler',
          surname: 'Vannurden',
        )

        expect(response.organizations[0]).to have_attributes(
          name: 'First Movers Advantage',
        )
      end
    end
  end
end
