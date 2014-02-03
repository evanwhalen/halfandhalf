Gem::Specification.new do |spec|
  spec.name = "halfandhalf"
  spec.version = "0.0.1"
  spec.homepage = "http://github.com/evanwhalen/halfandhalf"
  spec.license = "MIT"
  spec.summary = %Q{A/B testing for conversion funnels}
  spec.description = %Q{HalfAndHalf provides A/B testing for conversion funnels and calculates the statistical significance of effects on conversion rates at each step in a funnel.}
  spec.email = "evanwhalendev@gmail.com"
  spec.authors = ["Evan Whalen"]

  spec.files = `git ls-files`.split($/)
  spec.test_files = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "json"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rspec"
end