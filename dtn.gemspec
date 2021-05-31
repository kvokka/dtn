# frozen_string_literal: true

require_relative "lib/dtn/version"

Gem::Specification.new do |spec|
  spec.name          = "dtn"
  spec.version       = Dtn::VERSION
  spec.authors       = ["kvokka"]
  spec.email         = ["kvokka@yahoo.com"]

  spec.summary       = "Unofficial DTN (IQfeed) API."
  spec.description   = "Easy way tp access data from DTN (IQfeed)."
  spec.homepage      = "https://github.com/kvokka/dtn"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kvokka/dtn"
  spec.metadata["changelog_uri"] = "https://github.com/kvokka/dtn/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dry-configurable", "~> 0.12.0"
  spec.add_dependency "ractor-tvar", "~> 0.4.0"
  spec.add_dependency "zeitwerk", "~> 2.4.0"
end
