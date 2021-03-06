module FmadataParseName
  module V1
    class Response
      attr_reader :people, :organizations

      def initialize(json_response, response_code)
        @json_response = json_response
        @response_code = response_code

        @people = []
        @json_response['people_cache'] && @json_response['people_cache'].each do |parsed_name|
          @people << Person.new(parsed_name)
        end

        @organizations = []
        @json_response['organizations_cache'] && @json_response['organizations_cache'].each do |parsed_org|
          @organizations << Organization.new(parsed_org)
        end
      end

      def success?
        @json_response['parse_status'] == 200 && name_like_score > 0 || organizations.any?
      end

      def failure?
        !success?
      end

      def errors

      end

      private

      def name_like_score
        @json_response['name_like_score']
      end
    end
  end
end
