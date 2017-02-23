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
  spec.description   = %q{Namaz is AlAdhan.com wrapper in ruby to use REST API that is open for public use. The API only supports the GET method and returns JSON. Currently this includes Timings only}
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

  spec.add_dependency 'faraday', '~> 0'
  spec.add_dependency 'multi_json', '~> 0'
  spec.add_dependency 'hashie', '~> 0'

  spec.add_development_dependency 'typhoeus', '~> 0'
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
