
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "civic_duty/version"

Gem::Specification.new do |spec|
  spec.name          = "civic_duty"
  spec.version       = CivicDuty::VERSION
  spec.authors       = ["Marc-Andre Lafortune"]
  spec.email         = ["github@marc-andre.ca"]

  spec.summary       = %q{Gem library inspector.}
  spec.description   = %q{Gem library inspector}
  spec.homepage      = "https://github.com/marcandre/civic_duty"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "libraries_io"
  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "with_progress"
  spec.add_runtime_dependency "activerecord"
  spec.add_runtime_dependency "sqlite3"
  spec.add_runtime_dependency "require_relative_dir"
  spec.add_runtime_dependency "rugged"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "vcr", "~> 3.0"
end
