# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "zuora/version"

Gem::Specification.new do |s|
  s.name        = "zuora"
  s.version     = Zuora::Version.to_s
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Josh Martin"]
  s.email       = ["josh.martin@wildfireapp.com"]
  s.homepage    = "http://github.com/wildfireapp/zuora"
  s.summary     = %q{Zuora - ActiveModel backed client for the Zuora API}
  s.description = %q{Zuora - Easily integrate the Zuora SOAP API using ruby objects.}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.extra_rdoc_files = [ "README.md" ]

  s.add_runtime_dependency('savon', ["~> 0.9.8"])
  s.add_runtime_dependency('activesupport', [">= 3.0.0", "< 4.0.0"])
  s.add_runtime_dependency('activemodel', [">= 3.0.0", "< 4.0.0"])
  s.add_runtime_dependency('libxml4r', ['~> 0.2.6'])

  s.add_development_dependency('rake', ["~> 0.8.7"])
  s.add_development_dependency('guard-rspec', ["~> 0.6.0"])
  s.add_development_dependency('artifice', ["~> 0.6.0"])
  s.add_development_dependency('yard', ["~> 0.7.5"])
  s.add_development_dependency('rspec', ["~> 2.8.0"])
  s.add_development_dependency('redcarpet', ["~> 2.1.0"])
  s.add_development_dependency('factory_girl', ["~> 2.6.4"])
  s.add_development_dependency('appraisal', ["~> 0.4.1"])
  s.add_development_dependency('sqlite3', ["~> 1.3.0"])
  s.add_development_dependency('simplecov', ["~> 0.6.4"])
end
