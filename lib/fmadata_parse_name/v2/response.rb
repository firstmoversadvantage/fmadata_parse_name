module FmadataParseName
  module V2
    class Response
      attr_reader :people, :organizations

      def initialize(v2_json_response, response_code)
        @json_response = v2_json_response
        @code = response_code
        @people = []
        @organizations = []

        if @code == 200
          v2_json_response['name'] && v2_json_response['name'].each do |parsed_name|
            @people << Person.new(parsed_name)
          end

          v2_json_response['organization'] && v2_json_response['organization'].each do |parsed_org|
            @organizations << Organization.new(parsed_org)
          end
        else
          # TODO
        end
      end

      def success?
        @code == 200
      end

      def failure?
        !success
      end

      def errors
        if success?
          {}
        else
          @json_response['base']['errors']
        end
      end
    end
  end
end
