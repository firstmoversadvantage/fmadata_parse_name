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
          'https://v2.parse.name/api/v2/names/parse',
          params: { q: input, locale: 'en-US' },
          Authorization: @token,
          Accept: 'application/json',
          timeout: 5
        )

        json_response = JSON(response)

        Response.new(json_response, 200)
      rescue RestClient::Exception => e
        raise e if e.response.code == 401

        Response.new(JSON(e.response.body), e.response.code)
      end
    end
  end
end
