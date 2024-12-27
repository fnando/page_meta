# frozen_string_literal: true

require "./lib/page_meta/version"

Gem::Specification.new do |spec|
  spec.name          = "page_meta"
  spec.version       = PageMeta::VERSION
  spec.authors       = ["Nando Vieira"]
  spec.email         = ["me@fnando.com"]
  spec.required_ruby_version = Gem::Requirement.new(">= 3.2.0")
  spec.metadata = {
    "rubygems_mfa_required" => "true"
  }

  spec.summary       = "Easily define <meta> and <link> tags. I18n support " \
                       "for descriptions, keywords and titles."
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/fnando/page_meta"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`
                       .split("\x0")
                       .reject {|f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) {|f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">=6.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "minitest-utils"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-fnando"
  spec.add_development_dependency "simplecov"
end
