# frozen_string_literal: true

require_relative "lib/smartpay/version"

Gem::Specification.new do |spec|
  spec.name          = "smartpay"
  spec.version       = Smartpay::VERSION
  spec.authors       = ["Smartpay"]
  spec.email         = ["uxe@smartpay.co"]

  spec.summary       = "The Smartpay Ruby SDK offers easy access to Smartpay API from applications written in Ruby."
  spec.homepage      = "https://smartpay.co"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/smartpay-co/sdk-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/smartpay-co/sdk-ruby/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 2.1"

  spec.add_development_dependency "rspec", "~> 3.0"
end
