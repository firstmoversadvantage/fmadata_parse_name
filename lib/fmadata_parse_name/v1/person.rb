module FmadataParseName
  module V1
    class Person < FmadataParseName::Person
      def initialize(v1_parse_response)
        v1_response_without_blanks = delete_blank_keys(v1_parse_response)

        @given_name = v1_response_without_blanks['given_name']
        @secondary_name = v1_response_without_blanks['secondary_name']
        @surname = v1_response_without_blanks['surname']

        @salutations = v1_response_without_blanks['salutation']
        @credentials = v1_response_without_blanks['credentials']
        @prefixes = v1_response_without_blanks['prefix']
        @suffixes = v1_response_without_blanks['suffix']
        @alternate_name = v1_response_without_blanks['alternate_name']
        # @name_like_score = v1_response_without_blanks['name_like_score']
      end

      private

      def delete_blank_keys(hsh)
        hsh.reject do |k, v|
          v == ''
        end
      end

      def nilify_if_empty(str)
        str == '' ? nil : str
      end
    end
  end
end
