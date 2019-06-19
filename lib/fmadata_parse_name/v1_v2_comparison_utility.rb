# Used to compare results of v1 name parser with v2 name parser, until v1 is
# deprecated

module FmadataParseName
  class V1V2ComparisonUtility
    attr_reader :diff_message

    def initialize(input, v1_result, v2_result)
      @v1 = v1_result
      @v2 = v2_result
      @input = input
    end

    def compare
      compare_success && compare_people && compare_organizations
    end

    private

    def compare_success
      if @v1.success? == @v2.success?
        true
      else
        @diff_message = "v1 success?: #{@v1.success?} v2 success?: #{@v2.success?}"
        false
      end
    end

    def compare_people
      if @v1.people.count == @v2.people.count
        return true if @v1.people.count == 0

        # v1 will always return 1 person, so we can safely assume both returned 1 person

        v1_person1 = @v1.people[0]
        v2_person1 = @v2.people[0]

        name_metadata.each do |meta|
          unless v1_person1.send(meta) == v2_person1.send(meta)
            @diff_message = "metadata: #{meta} failed. v1: #{v1_person1.send(meta) || 'null'} v2: #{v2_person1.send(meta)}"
            return false
          end
        end

        true
      else
        @diff_message = "v1 people count: #{@v1.people.count} v2 people count: #{@v2.people.count}"
        false
      end
    end

    def compare_organizations
      if @v1.organizations.count == @v2.organizations.count
        return true if @v1.organizations.count == 0

        v1_org = @v1.organizations.first.name
        v2_org = @v2.organizations.first.name

        if v1_org == v2_org
          true
        else
          @diff_message = "v1 org: #{v1_org} v2 org: #{v2_org}"
          false
        end
      else
        @diff_message = "v1 org count: #{@v1.organizations.count} v2 org count: #{@v2.organizations.count}"
        false
      end
    end

    def name_metadata
      [
        :alternate_name,
        :salutations,
        :given_name,
        :secondary_name,
        :surname,
        :credentials,
        :job_titles,
        :prefixes,
        :suffixes
      ]
    end
  end
end
