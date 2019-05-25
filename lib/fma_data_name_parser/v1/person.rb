module FmaDataNameParser
  module V1
    class Person < FmaDataNameParser::Person
      def initialize(v1_parse_response)
        @given_name = v1_parse_response['given_name']
        @secondary_name = v1_parse_response['secondary_name']
        @surname = v1_parse_response['surname']

        @salutations = v1_parse_response['salutation']
        @credentials = v1_parse_response['credentials']
        @prefixes = v1_parse_response['prefix']
        @suffixes = v1_parse_response['suffix']
        @alternate_name = v1_parse_response['alternate_name']
        # @name_like_score = v1_parse_response['name_like_score']
      end
    end
  end
end
