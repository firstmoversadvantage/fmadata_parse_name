module FmadataParseName
  module V1
    class Client
      def initialize(token)
        @token = token
      end

      def parse(input)
        unless @token
          raise 'No authentication token given'
        end

        response = RestClient.get(
          'http://parse.name/names/parse.json',
          params: { q: input, token: @token },
          timeout: 5
        )

        json_response = JSON(response)

        if json_response['parse_status'] != 200
          raise FmadataParseName::ParseFailedError.new(
            "Parse status: #{json_response['parse_status']}"
          )
        end

        people = json_response['people_cache'] && json_response['people_cache'].map do |parsed_name|
          Person.new(parsed_name)
        end

        organizations = json_response['organizations_cache'].map do |parsed_org|
          Organization.new(parsed_org)
        end

        {
          people: people,
          organizations: organizations
        }
      end
    end
  end
end
