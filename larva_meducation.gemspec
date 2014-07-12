# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'larva_meducation/version'

Gem::Specification.new do |spec|
  spec.name          = "larva_meducation"
  spec.version       = LarvaMeducation::VERSION
  spec.authors       = ["iHiD"]
  spec.email         = ["jeremy@meducation.net"]
  spec.description   = %q{Meducation helper services for our pub/sub network}
  spec.summary       = %q{Some Meducation specific helper files for ur pub/sub network}
  spec.homepage      = "https://github.com/meducation/larva-meducation"
  spec.license       = "AGPL3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "larva", "~> 1.0"
  spec.add_dependency "meducation_sdk", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "minitest", "~> 5.0.8"
end
