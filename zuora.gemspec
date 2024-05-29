# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

unless ENV['CI_BRANCH'].nil?
  puts "CI Branch - #{ENV['CI_BRANCH']}"
  version = ENV['CI_BRANCH']
end

if /^v/.match?(version.downcase)
  version = version.dup
  version.slice!(0)
elsif /^build/.match?(version.downcase)
  version = "0.0.0.#{ENV['CI_BRANCH']}"
else
  version = '0.0.0'
end

Gem::Specification.new do |s|
  s.name        = 'zuora'
  s.version     = version
  s.authors     = ['Josh Martin']
  s.email       = ['josh.martin@wildfireapp.com']

  s.summary     = 'Zuora - ActiveModel backed client for the Zuora API'
  s.description = 'Zuora - Easily integrate the Zuora SOAP API using ruby objects.'
  s.homepage    = 'https://github.com/zuorasc/zuora'

  s.files       = Dir.glob('{bin,lib}/**/**/**')
  s.bindir = 'exe'
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  # s.platform    = Gem::Platform::RUBY
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  # s.require_paths = ["lib"]
  # s.extra_rdoc_files = [ "README.md" ]

  s.add_dependency 'activemodel', '< 5.0.0'
  s.add_dependency 'activesupport', '< 5.0.0'
  s.add_dependency 'libxml4r', '~> 0.2.6'
  s.add_dependency 'savon', '~> 0.9.8'
end
