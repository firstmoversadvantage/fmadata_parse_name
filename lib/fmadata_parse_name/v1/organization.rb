module FmadataParseName
  module V1
    class Organization < FmadataParseName::Organization
      def initialize(v1_parse_response)
        @name = v1_parse_response['name']
      end
    end
  end
end
