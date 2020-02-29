# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clear_logic/version'

Gem::Specification.new do |spec|
  spec.name          = 'clear_logic'
  spec.version       = ClearLogic::VERSION
  spec.authors       = ['bezrukavyi']
  spec.email         = ['yaroslav.bezrukavyi@gmail.com']

  spec.summary       = 'Clear result'
  spec.description   = 'Clear result'
  spec.homepage      = 'https://github.com/bezrukavyi/clear_logic'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-matcher', '>= 0.7'
  spec.add_dependency 'dry-monads', '>= 0.3.1'
  spec.add_dependency 'dry-transaction', '>= 0.12.0'
  spec.add_dependency 'dry-initializer', '>= 2.5.0'
  spec.add_dependency 'dry-types', '>= 1.0.0'
  spec.add_dependency 'dry-inflector'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'ffaker'
end
