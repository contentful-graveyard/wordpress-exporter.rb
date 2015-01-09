lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'wordpress-exporter'
  spec.version       = Version::VERSION
  spec.authors       = ['']
  spec.email         = ['']
  spec.description   = ''
  spec.summary       = ''
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables    << 'wordpress-exporter'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'http', '~> 0.6'
  spec.add_dependency 'multi_json', '~> 1'
  spec.add_dependency 'activesupport', '~> 4.1'
  spec.add_dependency 'escort', '~> 0.4.0'
  spec.add_dependency 'i18n', '~> 0.6'
  spec.add_dependency 'nokogiri', '~> 1.6.3.1'
  spec.add_dependency 'reverse_markdown', '~> 0.6.0'

  spec.add_development_dependency 'rspec', '~> 3'
  spec.add_development_dependency 'rspec-its', '~> 1.1.0'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
end
