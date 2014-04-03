# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "about_pos"
  spec.version       = `cat VERSION`
  spec.authors       = ["da99"]
  spec.email         = ["i-hate-spam-1234567@mailinator.com"]
  spec.summary       = %q{Provide more meta info while you  loop back/forth on your arrays.}
  spec.description   = %q{
    Whenever I loop through an array, there are times I wish I could
    know what comes before or after the item I am currently one.
    Including prev/next index calculations.  This gem helps you with
    that. However, it would be better for you to create your own
    since you will probably not like my way of doing it.
  }
  spec.homepage      = "https://github.com/da99/about_pos"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "bacon"
  spec.add_development_dependency "Bacon_Colored"
  spec.add_development_dependency "pry"
end
