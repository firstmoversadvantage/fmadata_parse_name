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
          params: { :q => input, :token => @token },
          :timeout => 5
        )

        json_response = JSON(response)

        Response.new(json_response, response.code)
      end
    end
  end
end
