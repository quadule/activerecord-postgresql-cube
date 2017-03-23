# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "activerecord-postgresql-cube/version"

Gem::Specification.new do |spec|
  spec.name          = "activerecord-postgresql-cube"
  spec.version       = ActiveRecordPostgreSQLCube::VERSION
  spec.authors       = ["Milo Winningham"]
  spec.email         = ["milo@winningham.net"]

  spec.summary       = %q{ActiveRecord support for the PostgreSQL cube data type.}
  spec.homepage      = "https://github.com/quadule/activerecord-postgresql-cube"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", "~> 5.0.0"
  spec.add_dependency "pg", ">= 0.18.4"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
