require 'bundler/setup'
require 'rspec/its'
ENV['DATABASE_URL'] = 'sqlite3::memory:'
require 'civic_duty'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :faraday
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.before(:suite) do
    CivicDuty.migrate
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
