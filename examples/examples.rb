require 'fmadata_parse_name'
require 'pry'

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





o1 = @v1_client.parse('First Movers Advantage, LLC')

o2 = @v2_client.parse('First Movers Advantage, LLC')

binding.pry
