# Used to compare results of v1 name parser with v2 name parser, until v1 is
# deprecated

module FmadataParseName
  class V1V2ComparisonUtility
    def initialize(input:, v1:, v2:)
      @v1 = v1
      @v2 = v2
      @input = input
    end

    def compare
      # puts "testing #{@input}"
      compare_success && compare_people && compare_organizations
    end

    private

    def compare_success
      if (@v1.status_code == 200) == @v2.success?
        true
      else
        p "#{@input} failed: v1: #{@v1.status_code} v2: #{@v2.status_code}"
        false
      end
    end

    def compare_people
      if @v1.people.count == @v2.people.count
        # v1 will always return 1 person, so we can safely assume both returned 1 person

        v1_person1 = @v1.people[0]
        v2_person1 = @v2.people[0]

        name_metadata.each do |meta|
          if meta == 'credential'
            # v1 calls this 'credentials', not 'credential'
            if (v1_person1.try(:[], 'credentials') == v2_person1.try(:[], meta)) || (v1_person1.try(:[], 'credentials').blank? == v2_person1.try(:[], meta).blank?)

            else
              # comparison failed for name metadata
              p "#{@input} for meta: #{meta} failed. v1: #{v1_person1[meta]} v2: #{v2_person1[meta]}"
            end
          else
            if (v1_person1.try(:[], meta) == v2_person1.try(:[], meta)) || (v1_person1.try(:[], meta).blank? == v2_person1.try(:[], meta).blank?)

            else
              # comparison failed for name metadata
              p "#{@input} for meta: #{meta} failed. v1: #{v1_person1[meta]} v2: #{v2_person1[meta]}"
            end
          end
        end

        true
      else
        # log the fact that v1 returned 1 person and v2 returned 2 people
        p "#{@input} people count failed. v1 count: #{@v1.people.count} v2 count: #{@v2.people.count}"
        false
      end
    end

    def compare_organizations
      if @v1.organizations.count == @v2.organizations.count
        v1_org = @v1.organizations.try(:[], 0).try(:[], 'name')
        v2_org = @v2.organizations.try(:[], 0).try(:[], 'name')

        if v1_org == v2_org
          true
        else
          p "#{@input} for org. v1: #{v1_org} v2: #{v2_org}"
          false
        end
      else
        p "#{@input} org count failed. v1 count: #{@v1.organizations.count} v2 count: #{@v2.organizations.count}"
        false
      end
    end

    def name_metadata
      %w(
        alternate_name
        salutation
        given_name
        secondary_name
        surname
        credential
        job_title
        prefix
        suffix
      )
    end

    # v1 is credentials
  end
end
