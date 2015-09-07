require_relative 'lib/kettle/version'

Gem::Specification.new do |s|
  s.name        = 'kettle'
  s.version     = Kettle::VERSION
  s.licenses    = ['Apache']
  s.summary     = 'Kettle manages your boilerplate!'
  s.authors     = ['David Danzilio']
  s.email       = 'david.danzilio@gmail.com'
  s.homepage    = 'https://github.com/ddanzilio/kettle'
  s.files       = Dir['lib/**/*.rb', 'bin/**/*', '*.md']
  s.executables = ['kettle']

  s.add_dependency 'thor', '~> 0.19.1'
  s.add_dependency 'git', '~> 1.2.9'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec-core'
  s.add_development_dependency 'aruba'
  s.add_development_dependency 'simplecov'
end
