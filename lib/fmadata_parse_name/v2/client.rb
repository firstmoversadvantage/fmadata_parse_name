module FmadataParseName
  module V2
    class Client
      def initialize(token)
        @token = token
      end

      def parse(input)
        unless @token
          raise 'No authentication token given'
        end

        response = RestClient.get(
          'http://v2.parse.name/api/v2/names/parse',
          params: { q: input, locale: 'en-US' },
          Authorization: @token,
          Accept: 'application/json',
          timeout: 5
        )

        json_response = JSON(response)

        people = []
        json_response['name'] && json_response['name'].each do |parsed_name|
          people << Person.new(parsed_name)
        end

        organizations = []
        json_response['organization'] && json_response['organization'].each do |parsed_org|
          organizations << Organization.new(parsed_org)
        end

        {
          people: people,
          organizations: organizations
        }
      rescue RestClient::BadRequest => e
        # json_response = JSON(e.response.body)
        raise FmadataParseName::ParseFailedError
      rescue => e
        raise FmadataParseName::ParseFailedError
      end
    end
  end
end
