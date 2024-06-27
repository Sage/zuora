# frozen_string_literal: true

$:.push File.expand_path('../lib', __FILE__)
require 'zuora/version'

Gem::Specification.new do |s|
  s.name        = 'sage-zuora'
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
  s.required_ruby_version = '>= 2.7'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'artifice'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'redcarpet'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'test-unit'
  s.add_development_dependency 'yard'
  s.add_dependency 'akami'
  s.add_dependency 'httpi'
  s.add_dependency 'libxml4r'
  s.add_dependency 'nokogiri'
  s.add_dependency 'rack'
  s.add_dependency 'savon'
  s.add_dependency 'wasabi'
end
