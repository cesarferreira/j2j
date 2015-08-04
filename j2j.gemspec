# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'j2j/version'

Gem::Specification.new do |spec|
  spec.name          = "j2j"
  spec.version       = J2j::VERSION
  spec.authors       = ["cesar ferreira"]
  spec.email         = ["cesar.manuel.ferreira@gmail.com"]

  spec.license       = 'MIT'
  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  spec.description   = %q{Write a longer description or delete this line.}
  spec.homepage      = "http://cesarferreira.com"

  # spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency 'pry-byebug', '~> 3.1'
  spec.add_development_dependency "coveralls"

  spec.add_dependency 'thor', '~> 0.19.1'
  spec.add_dependency 'colorize',  '~> 0.7'
  spec.add_dependency 'json', '~> 1.8.3'


end
