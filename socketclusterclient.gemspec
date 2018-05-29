require 'rake'

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'socketclusterclient/version'

Gem::Specification.new do |s|
  s.name        = 'socketclusterclient'
  s.version     = SocketClusterClient::VERSION
  s.platform    = Gem::Platform::RUBY
  s.licenses    = ['MIT']
  s.summary     = 'Ruby client for socketcluster'
  s.homepage    = 'https://socketcluster.io/'
  s.description = 'A socketcluster client designed in ruby'
  s.email       = %w[shahmaanav07@gmail.com piyushwww13@gmail.com sachinshinde7676@gmail.com]
  s.authors     = ['Maanav Shah', 'Piyush Wani', 'Sachin Shinde']

  s.files         = Rake::FileList['lib/**/*.rb']
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.2.0'

  s.add_dependency('websocket-eventmachine-client', '~> 1.2')
end
