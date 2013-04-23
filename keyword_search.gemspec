# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'keyword_search/version'

Gem::Specification.new do |spec|
  spec.name          = "keyword_search"
  spec.version       = KeywordSearch::VERSION
  spec.authors       = ["Bruce Williams", "Eric Lindvall"]
  spec.email         = ["brwcodes@gmail.com", "eric@sevenscale.com"]
  spec.summary       = %q{Generic library to parse GMail-style search strings for keyword/value pairs; supports definition of valid keywords and handling of quoted values.}
  spec.homepage      = %q{http://github.com/bruce/keyword_search}
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.rdoc_options  = ["--charset=UTF-8"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
