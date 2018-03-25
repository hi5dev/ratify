($: << File.expand_path('lib', __dir__)).uniq!

require 'ratify/version'

Gem::Specification.new do |spec|
  spec.name = 'ratify'
  spec.version = Ratify::VERSION
  spec.authors = ['Travis Haynes']
  spec.email = ['travis@hi5dev.com']
  spec.summary = 'Zero-dependency authorization gem.'
  spec.license = 'MIT'

  spec.bindir = 'exe'

  spec.files = `git ls-files -z`.split("\x0").reject do |file|
    file.match(%r{^(test)/})
  end

  spec.executables = spec.files.grep(%r{^#{spec.bindir}/}) do |file|
    File.basename(file)
  end

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
