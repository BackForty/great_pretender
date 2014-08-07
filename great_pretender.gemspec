# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'great_pretender/version'

Gem::Specification.new do |spec|
  spec.name          = "great_pretender"
  spec.version       = GreatPretender::VERSION
  spec.authors       = ["Flip Sasser"]
  spec.email         = ["flip@inthebackforty.com"]
  spec.summary       = %q{Ridiculously easy-to-use Rails mockups for those enlightened individuals who design in-browser}
  spec.description   = %q{Use Great Pretender to easily add layout-specific mockups in a Rails app without having to recreate the mockup wheel. Your design should be happening in-browser; this will help you get there.}
  spec.homepage      = "https://github.com/BackForty/great_pretender"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
