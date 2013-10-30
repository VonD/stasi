# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "stasi"
  spec.version       = "0.1.0"
  spec.authors       = ["Paul Vonderscher"]
  spec.email         = ["paul.vonderscher@gmail.com"]
  spec.description   = %q{a small authorization library}
  spec.summary       = %q{Schild und Schwert der Partei}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir["{lib,test}/**/*", "[A-Z]*", "init.rb"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", '~> 4.2'
  spec.add_development_dependency "turn"
  
  spec.add_dependency 'dsl_eval', '>= 0.0.2'
  spec.add_dependency 'activesupport', '>= 4.0.0'
  
end
