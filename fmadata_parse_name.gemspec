lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fmadata_parse_name/version'

Gem::Specification.new do |s|
  s.name          = 'fmadata_parse_name'
  s.version       = FmadataParseName::VERSION
  s.date          = '2019-05-10'
  s.summary       = "Wraps the parse.name and v2.parse.name name parsing APIs"
  s.authors       = ["Tyler VanNurden"]
  s.email         = 'tyler.vannurden@colorado.edu'

  all_files       = `git ls-files -z`.split("\x0")
  s.files         = all_files.grep(%r!^(exe|lib|rubocop)/|^.rubocop.yml$!)

  s.require_paths = ["lib"]
  s.homepage      = 'https://v2.parse.name'
  s.license       = 'MIT'

  s.add_runtime_dependency "rest-client", "~> 2.0"
  s.add_development_dependency "rspec", "~> 3.4"
  s.add_development_dependency "vcr", "~> 4.0"
  s.add_development_dependency "webmock", "~> 2.3"
  s.add_development_dependency "pry", "~> 0.12"
end
