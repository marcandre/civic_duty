require 'active_record'
require 'require_relative_dir'
require 'libraries_io'

module CivicDuty
  extend RequireRelativeDir
  require_relative 'civic_duty/version'
  require_relative_dir 'civic_duty/models'

  DEFAULT_DB_PATH = "./.vault.sqlite3"

  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || "sqlite3:#{DEFAULT_DB_PATH}")

  def self.libraries_io_api
    @libraries_io_api ||= LibrariesIO.new
  end

  def self.migrate(direction = :up)
    migrations = ActiveRecord::Migration.new.migration_context.migrations
    ActiveRecord::Migrator.new(direction, migrations, nil).migrate
  end
end
