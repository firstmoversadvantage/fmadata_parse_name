module FmadataParseName
  module V2
    class Response
      attr_reader :people, :organizations, :response_code

      def initialize(v2_json_response, response_code)
        @response_code = response_code

        if @response_code == 200
          @people = []
          v2_json_response['name'] && v2_json_response['name'].each do |parsed_name|
            @people << Person.new(parsed_name)
          end

          @organizations = []
          v2_json_response['organization'] && v2_json_response['organization'].each do |parsed_org|
            @organizations << Organization.new(parsed_org)
          end
        else

        end
      end

      def success?
        @response_code == 200
      end

      def failure?
        !success
      end

      def errors

      end
    end
  end
end
