require_relative "lib/klods/version"

Gem::Specification.new do |spec|
  spec.name = "klods-ruby"
  spec.version = Klods::VERSION
  spec.authors = ["Drue Wilding"]
  spec.email = ["drue@wilding.dk"]
  spec.summary = "Ruby builder API for klods — same components, same call shapes, same HTML output."
  spec.homepage = "https://github.com/druewilding/klods-ruby"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.files = Dir["lib/**/*", "LICENSE"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.0"
end
