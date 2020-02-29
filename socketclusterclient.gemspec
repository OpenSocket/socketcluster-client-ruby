lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'socketclusterclient/version'

Gem::Specification.new do |spec|
  spec.name        = 'socketclusterclient'
  spec.version     = Socketclusterclient::VERSION
  spec.authors     = ['Maanav Shah', 'Piyush Wani', 'Sachin Shinde']
  spec.email       = %w[shahmaanav07@gmail.com piyushwww13@gmail.com sachinshinde7676@gmail.com]

  spec.platform    = Gem::Platform::RUBY
  spec.licenses    = ['MIT']

  spec.summary     = 'Ruby client for socketcluster'
  spec.description = 'A socketcluster client designed in ruby'
  spec.homepage    = 'https://socketcluster.io/'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.2.0'

  spec.add_development_dependency('bundler', '~> 1.16')
  spec.add_development_dependency('rake', '~> 13.0')
  spec.add_development_dependency('rspec', '~> 3.0')
  spec.add_development_dependency('simplecov', '~> 0.16')
  spec.add_dependency('websocket-eventmachine-client', '~> 1.2')
end
