# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "great_pretender/version"

Gem::Specification.new do |spec|
  spec.name = "great_pretender"
  spec.version = GreatPretender::VERSION
  spec.authors = ["Flip Sasser"]
  spec.email = ["flip@inthebackforty.com"]
  spec.summary = "Ridiculously easy-to-use Rails mockups for those enlightened individuals who design in-browser"
  spec.description = "Use Great Pretender to easily add layout-specific mockups in a Rails app without having to recreate the mockup wheel. Your design should be happening in-browser; this will help you get there."
  spec.homepage = "https://github.com/BackForty/great_pretender"
  spec.license = "MIT"

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.3"
  spec.add_development_dependency "rake", "~> 10.0"
end
