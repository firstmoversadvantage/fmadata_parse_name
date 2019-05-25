module FmadataParseName
  module V2
    class Organization < FmadataParseName::Organization
      def initialize(v2_parse_response)
        @name = v2_parse_response['name']
      end

      def is_a_team?
        !!(/\bteam\b/i =~ @name)
      end

      # mostly to preserve v1 name parser functionality
      def [](key)

      end
    end
  end
end
