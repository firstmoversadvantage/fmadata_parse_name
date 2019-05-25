# fmadata_parse_name
A Ruby gem for communicating with the v1 and v2 name parsing services.

Note: the format of this readme was inspired by the Twilio rubygem readme, https://github.com/twilio/twilio-ruby/blob/master/README.md

## Installation

To install using [Bundler][bundler]:

```ruby
gem 'fmadata_parse_name'
```

To manually install `fmadata_parse_name` via [Rubygems][rubygems] simply gem install:

```bash
gem install fmadata_parse_name
```

## Getting Started

### Setup Work

```ruby
require 'fmadata_parse_name'

# put your own credentials here
api_token = 'my-api-token'

# set up a client to talk to the Twilio REST API
@client = Twilio::REST::Client.new account_sid, auth_token
```

### Make a Call

```ruby
@client.api.account.calls.create(
  from: '+14159341234',
  to: '+16105557069',
  url: 'http://example.com'
)
```

### Send an SMS

```ruby
@client.api.account.messages.create(
  from: '+14159341234',
  to: '+16105557069',
  body: 'Hey there!'
)
```

### List your SMS Messages

```ruby
@client.api.account.messages.list
```

### Fetch a single SMS message by Sid

```ruby
# put the message sid you want to retrieve here:
message_sid = 'SMxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
@client.api.account.messages(message_sid).fetch
```

### Customizing your HTTP Client
twilio-ruby uses [Faraday][faraday] to make HTTP requests. You can tell
Twilio::REST::Client to use any of the Faraday adapters like so:

```ruby
@client.http_client.adapter = :typhoeus
```

## Getting Started With Client Capability Tokens

If you just need to generate a Capability Token for use with Twilio Client, you
can do this:

```ruby
require 'twilio-ruby'

# put your own account credentials here:
account_sid = 'ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
auth_token = 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy'

# set up
capability = Twilio::JWT::ClientCapability.new account_sid, auth_token

# allow outgoing calls to an application
outgoing_scope = Twilio::JWT::ClientCapability::OutgoingClientScope.new 'AP11111111111111111111111111111111'
capability.add_scope(outgoing_scope)

# allow incoming calls to 'andrew'
incoming_scope = Twilio::JWT::ClientCapability::IncomingClientScope.new 'andrew'
capability.add_scope(incoming_scope)

# generate the token string
@token = capability.to_s
```

There is a slightly more detailed document in the [Capability][capability]
section of the wiki.

## Getting Started With TwiML

You can construct a TwiML response like this:

```ruby
require 'twilio-ruby'

response = Twilio::TwiML::VoiceResponse.new do |r|
  r.say(message: 'hello there', voice: 'alice')
  r.dial(caller_id: '+14159992222') do |d|
    d.client 'jenny'
  end
end

# print the result
puts response.to_s
```

This will print the following (except for the whitespace):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<Response>
  <Say voice="alice">hello there</Say>
  <Dial callerId="+14159992222">
    <Client>jenny</Client>
  </Dial>
</Response>
```

## Supported Ruby Versions

This library supports and is [tested against][travis] the following Ruby
implementations:

- Ruby 2.5.0
- Ruby 2.4.0
- Ruby 2.3.0
- Ruby 2.2.0

[capability]: https://github.com/twilio/twilio-ruby/wiki/JWT-Tokens
[examples]: https://github.com/twilio/twilio-ruby/blob/master/examples
[documentation]: http://twilio.github.io/twilio-ruby
[wiki]: https://github.com/twilio/twilio-ruby/wiki
[bundler]: http://bundler.io
[rubygems]: http://rubygems.org
[gem]: https://rubygems.org/gems/twilio
[travis]: http://travis-ci.org/twilio/twilio-ruby
[upgrade]: https://github.com/twilio/twilio-ruby/wiki/Ruby-Version-5.x-Upgrade-Guide
[issues]: https://github.com/twilio/twilio-ruby/issues
[faraday]: https://github.com/lostisland/faraday

## Making changes to the gem

```
gem build fmadata_parse_name.gemspec
```
