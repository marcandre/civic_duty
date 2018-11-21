require 'bundler/setup'
require 'rspec/its'
require 'rspec/expectations'
ENV['DATABASE_URL'] = 'sqlite3::memory:'
ENV['VAULT_REPOSITORY'] = "#{__dir__}/fixtures"
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

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
