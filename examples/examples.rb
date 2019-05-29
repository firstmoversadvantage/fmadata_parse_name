require 'fmadata_parse_name'

v1_api_token = 'c104048a-1f32-467c-9022-4b90d8893f85'
v2_api_token = '66039622-9040-4964-bfe2-8ce4d1176724'

# Initialize a v1 client
@v1_client = FmadataParseName::V1::Client.new(v1_api_token)

# Parse against v1
p1 = @v1_client.parse('Tyler Kenneth Van Nurden')

# Get the first person parsed
p1[:people].first

# Initialize a v2 client
@v2_client = FmadataParseName::V2::Client.new(v2_api_token)

# Parse against v2
p2 = @v2_client.parse('Tyler Kenneth Van Nurden')

# Get the first person parsed
p2[:people].first



# Parse an organization
o1 = @v1_client.parse('First Movers Advantage, LLC')
o2 = @v2_client.parse('First Movers Advantage, LLC')



# Parse an input that contains two names:
# NOTE v1 doesn't support this feature, and only pulls the first name
@v1_client.parse('Jeff and Pam McGuire')

@v2_client.parse('Jeff and Pam McGuire')



# Parse an input that contains a name and an organization
# NOTE v1 doesn't support this feature, and only returns the first name
# that it finds
@v1_client.parse('Brian Long, First Movers Advantage, LLC')

@v2_client.parse('Brian Long, First Movers Advantage, LLC')




# Compare the results of a v1 parse with a v2 parse
# This could be useful for phasing the v2 parser into your system,
# and help you understand new scenarios to code for

# When both parsers return the same thing
input = 'First Movers Advantage, LLC'
o1 = @v1_client.parse(input)
o2 = @v2_client.parse(input)

compare1 = FmadataParseName::V1V2ComparisonUtility.new(
  input: input,
  v1_result: o1,
  v2_result: o2
)

compare1.compare # => true




# When parsers return something different
input2 = 'Bill and Melinda Gates'

v1 = @v1_client.parse(input2)
v2 = @v2_client.parse(input2)

compare2 = FmadataParseName::V1V2ComparisonUtility.new(input: input2, v1_result: v1, v2_result: v2)

compare2.compare # => false
compare2.diff_message # => 'v1 people count: 1 v2 people count: 2'
