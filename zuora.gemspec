# frozen_string_literal: true

$:.push File.expand_path('../lib', __FILE__)
require 'zuora/version'

Gem::Specification.new do |s|
  s.name        = 'zuora'
  s.version     = Zuora::Version.to_s
  s.authors     = ['Josh Martin']
  s.email       = ['josh.martin@wildfireapp.com']
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

  s.add_dependency 'activemodel', '< 5.0.0'
  s.add_dependency 'activesupport', '< 5.0.0'
  s.add_dependency 'akami', '1.3.2'
  s.add_dependency 'ffi', '1.16.3'
  s.add_dependency 'httpi', '~> 1.0'
  s.add_dependency 'libxml4r', '~> 0.2.6'
  s.add_dependency 'nokogiri', '~> 1.15.6'
  s.add_dependency 'ruby3-backward-compatibility'
  s.add_dependency 'savon', '~> 0.9.12'
  s.add_dependency 'wasabi', '2.3.0'
end
