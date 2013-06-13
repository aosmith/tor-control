# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mantra-tor/version'

Gem::Specification.new do |spec|
  spec.name          = "tor-control"
  spec.version       = TorControl::VERSION
  spec.authors       = ["Alex Smith"]
  spec.email         = ["aosmith@gmail.com"]
  spec.description   = %q{A tor control gem.}
  spec.summary       = %q{Hide behind the onion!}
  spec.homepage      = "http://alexsmith.io/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rspec", "~> 2.13.0"
end
