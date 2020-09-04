# fmadata_parse_name
A Ruby gem for communicating with the v1 and v2 name parsing API services.

[V1 Name Parser API](http://parse.name)

[V2 Name Parser API](https://v2.parse.name)

## Installation

```ruby
# Gemfile
gem 'fmadata_parse_name', '~> 1.0', git: 'git@github.com:firstmoversadvantage/fmadata_parse_name.git'
```

OPTIONAL
You can set PARSE_NAME_HOST env variable in .env file. This might be helpful for development purposes if you need parse.name running locally on your machine.
Remember, to change also V2_PARSE_NAME_TOKEN env to the token of one of your locally existing users.

```
PARSE_NAME_HOST=http://localhost:3000/
```

## Getting Started

### Setup

There are two different client classes for interraction. One for the v1 name parser, and one for v2. **For new development, you should only use version 2, since version 1 will soon be retired.** The v2 parser has many advantages over v1, and are outlined [here](https://v2.parse.name).

```ruby
require 'fmadata_parse_name'

# Find your own credentials by visiting https://v2.parse.name/users/edit
v2_api_token = 'my-v2-api-token'

# Initialize a v2 client
@v2_client = FmadataParseName::V2::Client.new(v2_api_token)
```

### Make some calls by calling `FmadataParseName::V2::Client#parse`

```ruby
# Parse an input that results in a name
@v2_client.parse('Tyler Kenneth Van Nurden')

# Parse an input that results in an organization
@v2_client.parse('First Movers Advantage, LLC')

# Parse an input that results in a name + an organization
@v2_client.parse('Tyler Van Nurden, First Movers Advantage')

# Parse an input that results in two names
@v2_client.parse('Jeff and Pam McGuire')
```

The `#parse` method will return a `Response` object, which responds to the following instance methods:

#### `#people`
An Array of `Person` objects, which responds to:
```
#given_name
#secondary_name
#surname
#salutations
#credentials
#job_titles
#prefixes
#suffixes
#alternate_name
```

#### `#organizations`
An Array of `Organization` objects, which responds to:
```
#name
```

#### It also responds to these instance methods:
```
#success? => True or False representing whether or not we could parse the input succcessfully
#failure?
#errors => Hash of errors returned from the parser
```

**After parsing, you should always check whether or not the parse was successful, because exceptions are not raised automatically if a parse was unsuccessful.**

```ruby
response = @v2_client.parse('Tyler')
response.success? => false
```

### Parsing against the v1 name parser

You should only implement the `FmadataParseName::V1` classes in your application if you already use the v1 name parser **and** are interested in seeing the diff between a v1 parse and a v2 parse. Again, the v1 name parser will soon be retired in lieu of v2.

```ruby
v1_api_token = 'my-v1-api-token'

@v1_client = FmadataParseName::V1::Client.new(v1_api_token)

@v1_client.parse('Tyler Kenneth Van Nurden')

@v1_client.parse('First Movers Advantage, LLC')

# v1 will only return the first name, Jeff McGuire
@v1_client.parse('Jeff and Pam McGuire')
```

### Comparing v1 and v2 parses via `FmadataParseName::V1V2ComparisonUtility`

```ruby
# When parsers return the same thing:
input = 'Tyler Kenneth Van Nurden'

v1_response = @v1_client.parse(input)
v2_response = @v2_client.parse(input)

v1_v2_comparison = FmadataParseName::V1V2ComparisonUtility.new(
  input: input,
  v1_result: v1_response,
  v2_result: v2_response
)

v1_v2_comparison.compare => true # returns `true` when they both returned the same result



# When parsers return something different:
input2 = 'Bill and Melinda Gates'

v1_response = @v1_client.parse(input2)
v2_response = @v2_client.parse(input2)

v1_v2_comparison = FmadataParseName::V1V2ComparisonUtility.new(
  input: input2,
  v1_result: v1_response,
  v2_result: v2_response
)

v1_v2_comparison.compare # => false
v1_v2_comparison.diff_message # => 'v1 people count: 1 v2 people count: 2'
```

The intent of the `diff_message` is to integrate it into your application's logging so that differences can be reviewed and coded for.

## Making changes to the gem

```
gem build fmadata_parse_name.gemspec
```
