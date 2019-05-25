module FmaDataNameParser
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
      rescue RestClient::BadRequest => e
        @status_code = e.response.code
        @response = JSON(e.response.body)
        @error = @response['base']['errors']
        false
      rescue RestClient::InternalServerError => e
        @status_code = e.response.code
        @response = JSON(e.response.body)
        false
      end
    end
  end
end
