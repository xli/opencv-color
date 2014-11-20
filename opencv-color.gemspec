# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'opencv-color/version'

Gem::Specification.new do |spec|
  spec.name          = "opencv-color"
  spec.version       = OpenCVColor::VERSION
  spec.authors       = ["Xiao Li"]
  spec.email         = ["swing1979@gmail.com"]
  spec.summary       = %q{Learn OpenCV HSV color range from sample images.}
  spec.description   = %q{OpenCV is a great library for writing Computer Vision software, However, OpenCV's HSV format is different than what you would expect! This gem trys to learn HSV color range from sample images for your OpenCV program to detect color.}
  spec.homepage      = "https://github.com/xli/opencv-color"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('ruby-opencv', "~> 0.0.13")
  spec.add_dependency('statsample', "~> 1.4.0")
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
