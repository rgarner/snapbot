# frozen_string_literal: true

require_relative "lib/snapbot/version"

Gem::Specification.new do |spec|
  spec.name = "snapbot"
  spec.version = Snapbot::VERSION
  spec.authors = ["Russell Garner"]
  spec.email = ["rgarner@zephyros-systems.co.uk"]

  spec.summary = "A `save_and_open_diagram` tool to visualise ActiveRecord test records"
  spec.homepage = "https://github.com/rgarner/snapbot"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/rgarner/snapbot"
  spec.metadata["changelog_uri"] = "https://github.com/rgarner/snapbot/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "binding_of_caller", "~> 1.0"

  version_string = [">= 6.1"]
  spec.add_runtime_dependency "actionpack", version_string
  spec.add_runtime_dependency "activerecord", version_string
  spec.add_runtime_dependency "activesupport", version_string

  spec.add_development_dependency "rbs"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "steep"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
