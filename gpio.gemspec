# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gpio/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby-gpio"
  spec.version       = Gpio::VERSION
  spec.authors       = ["Chang Sau Sheong"]
  spec.email         = ["sausheong@gmail.com"]
  spec.summary       = %q{A Ruby DSL to interface with the Raspberry Pi GPIO.}
  spec.description   = %q{Wraps around the Linux sysfs GPIO interface to control GPIO pins. Also watches pins and trigger handlers accordingly.}
  spec.homepage      = "https://github.com/sausheong/ruby-gpio"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "concurrent-ruby", "~> 1.0" 
  spec.add_runtime_dependency "concurrent-ruby-ext", "~> 1.0"
end
