module FmadataParseName
  module V2
    class Organization < FmadataParseName::Organization
      def initialize(v2_parse_response)
        @name = v2_parse_response['name']
        @name_like_score = v2_parse_response['name_like_score']
      end
    end
  end
end
