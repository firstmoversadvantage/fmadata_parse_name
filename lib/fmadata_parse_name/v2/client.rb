module FmadataParseName
  module V2
    class GatewayError < StandardError; end

    class Client
      def initialize(token)
        @token = token
      end

      def parse(input)
        unless @token
          raise 'No authentication token given'
        end

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
      rescue JSON::ParserError => e
        raise e unless response.code == 502 || response.body.include?('Bad Gateway')

        retries = (retries || 1) + 1
        sleep(1) && retry if retries <= 3

        raise GatewayError
      rescue RestClient::Exception => e
        raise e if e.response.code == 401

        if [502, 504].include? e.response.code
          retries = (retries || 1) + 1
          sleep(1) && retry if retries <= 3

          return Response.new(gateway_error_body(e.response.code), e.response.code)
        end
        Response.new(JSON(e.response.body), e.response.code)
      end

      private
      def set_url
        host_name = ENV['PARSE_NAME_HOST'] || 'https://v2.parse.name/'

        host_name + "api/v2/names/parse"
      end

      def gateway_error_body(code)
        {
          'base' => {
            'errors' => {
              'error' => ["#{code} Gateway Error"]
            }
          }
        }
      end
    end
  end
end
