lib = File.expand_path("lib")
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fmadata_parse_name/version'

Gem::Specification.new do |s|
  s.name          = 'fmadata_parse_name'
  s.version       = FmadataParseName::VERSION
  s.date          = '2019-05-10'
  s.summary       = "Wraps the parse.name and v2.parse.name name parsing APIs"
  s.authors       = ["Tyler VanNurden"]
  s.email         = 'tyler.vannurden@colorado.edu'

  s.required_ruby_version = '>= 1.8.7'

  all_files       = `git ls-files -z`.split("\x0")
  s.files         = all_files.grep(%r!^(exe|lib|rubocop)/|^.rubocop.yml$!)

  s.require_paths = ["lib"]
  s.homepage      = 'https://v2.parse.name'
  s.license       = 'MIT'

  s.add_runtime_dependency "rest-client", "~> 1.6.0"
  s.add_development_dependency "rspec", "~> 3.4"
  s.add_development_dependency "vcr", "3.0.0"
  # s.add_development_dependency "typhoeus"
  # s.add_development_dependency "public_suffix", "1.4.6"
  # s.add_development_dependency "addressable", "~> 2.3.8"
  # s.add_development_dependency "hashdiff", "0.3.6"
  # s.add_development_dependency "webmock", "~> 1.24.0"
end
