module FmadataParseName
  module V1
    class Organization < FmadataParseName::Organization
      def initialize(v1_parse_response)
        @name = v1_parse_response['name']
        @name_like_score = v1_parse_response['name_like_score']
      end
    end
  end
end
