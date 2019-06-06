require 'spec_helper'

describe FmadataParseName::V1::Response do
  let(:client) do
    FmadataParseName::V1::Client.new('7d112490-ff1e-4759-9af1-a3b30a2cc87a')
  end

  describe '#success?' do
    it 'returns true when the parse was successful', :vcr do
      response = client.parse('tyler vannurden')
      expect(response.success?).to eq(true)
    end

    it 'returns false when the parse was unsuccessful', :vcr do
      response = client.parse('a b c d e f g h i j k l m n o p')
      expect(response.success?).to eq(false)
    end
  end
end
