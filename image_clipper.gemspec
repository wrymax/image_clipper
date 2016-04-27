# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'image_clipper/version'

Gem::Specification.new do |spec|
  spec.name          = "image_clipper"
  spec.version       = ImageClipper::VERSION
  spec.authors       = ["wrymax"]
  spec.email         = ["wryma@qq.com"]
  spec.description   = %q{An easy tool for image processing. All functions are based on ImageMagick.}
  spec.summary       = %q{An easy tool for image processing.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
	spec.add_development_dependency "rspec"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
end
