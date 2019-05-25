# lib = File.expand_path('../lib', __FILE__)
# $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fma_data_name_parser'

Gem::Specification.new do |s|
  s.name          = 'fma_data_name_parser'
  s.version       = FmaDataNameParser::VERSION
  s.date          = '2019-05-10'
  s.summary       = "Wraps the parse.name and v2.parse.name name parsing APIs"
  s.authors       = ["Tyler VanNurden"]
  s.email         = 'tyler.vannurden@colorado.edu'
  s.files         = ["lib/fma_data_name_parser.rb"]
  s.require_paths = ["lib"]
  s.homepage      = 'https://v2.parse.name'
  s.license       = 'MIT'

  s.add_runtime_dependency "rest-client", "~> 2.0"
  s.add_development_dependency "rspec", "~> 3.4"
  s.add_development_dependency "vcr"
  s.add_development_dependency "webmock"
  s.add_development_dependency "pry"
end
