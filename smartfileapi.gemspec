# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smartfile-api/version'

Gem::Specification.new do |spec|
  spec.name          = 'smartfile-api'
  spec.version       = SmartFileApi::VERSION
  spec.authors       = ['Robin Cheptileh']
  spec.email         = ['robincheptileh@gmail.com']

  spec.summary       = %q{Fully featured smartfile api implementation for ruby}
  spec.description   = %q{Fully featured ruby implementation for the SmartFile API}
  spec.homepage      = 'https://github.com/RobinCheptileh/smartfileapi'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 1.9'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'figaro'
  spec.add_dependency 'rest-client'
  spec.add_dependency 'json'
end
