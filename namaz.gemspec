# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'namaz/version'

Gem::Specification.new do |spec|
  spec.name          = "namaz"
  spec.version       = Namaz::VERSION
  spec.authors       = ["Sohair Ahmad"]
  spec.email         = ["sohair1991@gmail.com"]

  spec.summary       = %q{Returns all prayer times for a specific date}
  spec.description   = %q{Namaz gem is AlAdhan.com wrapper in ruby to use REST API that is open for public use.}
  spec.homepage      = "https://github.com/Sohair63/namaz"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday'
  spec.add_dependency 'multi_json'
  spec.add_dependency 'hashie'

  spec.add_development_dependency 'typhoeus', '~> 1'
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.10"
end
