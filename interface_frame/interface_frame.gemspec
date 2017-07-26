# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'interface_frame/version'

Gem::Specification.new do |spec|
  spec.name          = "interface_frame"
  spec.version       = InterfaceFrame::VERSION
  spec.authors       = ["Anion"]
  spec.email         = ["anion102@126.com"]

  spec.summary       = spec.description   = %q{InterfaceFrame is Automated Test Framework that examining interface services for mobanker.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
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

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "3.4.0"
  spec.add_development_dependency "rest-client", "2.0.0"
  spec.add_development_dependency "activerecord", "4.2.6"
  spec.add_development_dependency "mysql2", "0.4.4"
  spec.add_development_dependency "mail"
end
