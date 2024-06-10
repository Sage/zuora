# frozen_string_literal: true

$:.push File.expand_path('../lib', __FILE__)
require 'zuora/version'

Gem::Specification.new do |s|
  s.name        = 'zuora'
  s.version     = Zuora::Version.to_s
  s.authors     = ['Sage Accounting']
  s.email       = ['sageone@sage.com']
  s.summary     = 'Zuora - ActiveModel backed client for the Zuora API'
  s.description = 'Zuora - Easily integrate the Zuora SOAP API using ruby objects.'
  s.homepage    = 'https://github.com/zuorasc/zuora'

  s.files       = Dir.glob('{bin,lib}/**/**/**')
  s.bindir = 'exe'
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']
  s.platform    = Gem::Platform::RUBY
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = ['README.md']

  s.add_development_dependency 'akami', '<= 1.3.2'
  s.add_development_dependency 'appraisal', '~> 0.4.1'
  s.add_development_dependency 'artifice', '~> 0.6.0'
  s.add_development_dependency 'bigdecimal', '< 2.0.0'
  s.add_development_dependency 'factory_girl', '~> 2.6.4'
  s.add_development_dependency 'ffi', '<= 1.16.3'
  s.add_development_dependency 'guard-rspec', '~> 0.6.0'
  s.add_development_dependency 'nokogiri', '~> 1.15.6'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-nav'
  s.add_development_dependency 'rake', '~> 0.8.7'
  s.add_development_dependency 'redcarpet', '~> 2.1.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'simplecov', '~> 0.6.4'
  s.add_development_dependency 'sqlite3', '~> 1.3.0'
  s.add_development_dependency 'test-unit'
  s.add_development_dependency 'wasabi', '2.3.0'
  s.add_development_dependency 'yard', '~> 0.7.5'

  s.add_dependency 'activemodel', '< 5.0.0'
  s.add_dependency 'activesupport', '< 5.0.0'
  s.add_dependency 'httpi', '~> 1.0'
  s.add_dependency 'libxml4r', '~> 0.2.6'
  s.add_dependency 'savon', '~> 0.9.12'
end
