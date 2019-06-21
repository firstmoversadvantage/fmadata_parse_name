module FmadataParseName
  module V2
    class Person < FmadataParseName::Person
      def initialize(v2_parse_response)
        @given_name = v2_parse_response['given_name']
        @secondary_name = v2_parse_response['secondary_name']
        @surname = v2_parse_response['surname']

        @salutations = v2_parse_response['salutation'] || []
        @credentials = v2_parse_response['credential'] || []
        @job_titles = v2_parse_response['job_title'] || []
        @prefixes = v2_parse_response['prefix'] || []
        @suffixes = v2_parse_response['suffix'] || []
        @alternate_name = v2_parse_response['alternate_name'] || []
      end
    end
  end
end
