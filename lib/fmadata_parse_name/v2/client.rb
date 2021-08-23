module FmadataParseName
  module V2
    class Client
      def initialize(token)
        @token = token
      end

      def parse(input)
        raise 'No authentication token given' unless @token

        retries ||= 0
        url = set_url

        response = RestClient.get(
          url,
          params: { q: input, locale: 'en-US' },
          Authorization: @token,
          Accept: 'application/json',
          timeout: 5
        )

        json_response = JSON(response)

        Response.new(json_response, 200)
      rescue RestClient::Exception => e
        case e.response.code
        when 401
          raise e
        when 502, 504
          sleep(1) && retry if (retries += 1) < 3

          raise e
        end

        Response.new(JSON(e.response.body), e.response.code)
      end

      private

      def set_url
        host_name = ENV['PARSE_NAME_HOST'] || 'https://v2.parse.name/'

        host_name + "api/v2/names/parse"
      end
    end
  end
end
