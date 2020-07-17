require_relative 'lib/covid_pt/version'

Gem::Specification.new do |spec|
  spec.name          = "covid_pt"
  spec.version       = CovidPT::VERSION
  spec.authors       = ["Fernando Mendes"]
  spec.email         = ["fernando@mendes.codes"]

  spec.summary       = %q{COVID19 data fetcher and parser for Portugal}
  spec.homepage      = "https://github.com/frm/covid_pt"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/frm/covid_pt"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sort_alphabetical"
  spec.add_dependency "pdf-reader"
  spec.add_dependency "rest-client"
  spec.add_development_dependency "rubocop"
end
