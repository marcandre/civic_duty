require 'bundler/setup'
require 'rspec/its'
require 'rspec/expectations'
ENV['DATABASE_URL'] = 'sqlite3::memory:'
ENV['VAULT_REPOSITORY'] = "#{__dir__}/fixtures"
require 'vcr'
require 'civic_duty'

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

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.expose_dsl_globally = true

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

require_relative 'shared_context'
