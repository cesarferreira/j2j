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
  spec.summary       = %q{Convert any Files.json to corresponding Classe.java files}
  spec.description = <<-EOF
    Convert any Files.json to corresponding Classe.java files
  EOF

  #spec.extra_rdoc_files = ['README', 'README.md']

  spec.post_install_message = <<-EOF
    Thanks for installing!
    Head here for documentation: https://github.com/cesarferreira/j2j
  EOF

  spec.metadata = { "issue_tracker" => "https://example/issues" }

  spec.homepage      = "https://github.com/cesarferreira/j2j"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency 'pry-byebug', '~> 3.1'

  spec.add_dependency 'thor', '~> 0.19.1'
  spec.add_dependency 'colorize',  '~> 0.7'
  spec.add_dependency 'json', '~> 1.8.3'
  spec.add_dependency 'activesupport', '~> 4.2'

end
