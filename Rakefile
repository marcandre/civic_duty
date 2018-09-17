require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

namespace :db do
  task :migrate do
    require_relative 'lib/civic_duty'
    CivicDuty.migrate
  end

  task :down do
    require_relative 'lib/civic_duty'
    CivicDuty.migrate :down
  end
end
