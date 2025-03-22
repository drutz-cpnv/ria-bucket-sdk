# frozen_string_literal: true

require_relative "lib/bucket_sdk/version"

Gem::Specification.new do |spec|
  spec.name = "bucket_sdk"
  spec.version = BucketSdk::VERSION
  spec.authors = ["drutz-cpnv"]
  spec.email = ["dimitri.rutz@eduvaud.ch"]

  spec.summary = "Ruby SDK for the Bucket Storage Service"
  spec.description = "A Ruby client for interacting with the Bucket API to upload and list files"
  spec.homepage = "https://github.com/drutz-cpnv/ria-bucket-sdk"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/drutz-cpnv/ria-bucket-sdk"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "faraday", "~> 2.7"
  spec.add_dependency "faraday-multipart", "~> 1.0"
  spec.add_dependency "zeitwerk", "~> 2.6"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
