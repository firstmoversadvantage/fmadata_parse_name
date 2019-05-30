module FmadataParseName
  module V2
    class Organization < FmadataParseName::Organization
      def initialize(v2_parse_response)
        @name = v2_parse_response['name']
      end
    end
  end
end
