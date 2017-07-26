# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ui_framework/version'

Gem::Specification.new do |spec|
  spec.name          = "ui_framework"
  spec.version       = UiFramework::VERSION
  spec.authors       = ["anion102"]
  spec.email         = ["anion102@126.com"]

  spec.summary       = %q{the framework work for app&web automated testing.}
  spec.description   = %q{the framework work for app&web automated testing.}
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
  spec.add_development_dependency "appium_lib", "8.0.2"
  spec.add_development_dependency "watir-scroll", "~> 0.1"
  spec.add_development_dependency "watir", "~> 5.0"
  spec.add_development_dependency "watir-webdriver", "~> 0.9"
  spec.add_development_dependency "selenium-webdriver", "~> 2.53"
  spec.add_development_dependency "spreadsheet", "~> 1.1"
  spec.add_development_dependency "mail", "~> 2.6"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "activerecord", "4.2.6"
  spec.add_development_dependency "mysql2", "0.4.4"
end
