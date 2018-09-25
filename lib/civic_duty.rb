require 'active_record'
require 'require_relative_dir'
require 'libraries_io'
autoload :Rugged, 'rugged'

module CivicDuty
  extend RequireRelativeDir
  require_relative 'civic_duty/version'
  require_relative_dir 'civic_duty/models'

  DEFAULT_DB_PATH = './.vault.sqlite3'
  DEFAULT_VAULT_REPOSITORY_REPO_PATH = './vault'

  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || "sqlite3:#{DEFAULT_DB_PATH}")

  class << self
    def libraries_io_api
      @libraries_io_api ||= LibrariesIO.new
    end

    def repo
      @repo ||= begin
        vault = ENV['VAULT_REPOSITORY'] || DEFAULT_VAULT_REPOSITORY_REPO_PATH
        unless Dir.exist?(vault)
          Dir.mkdir(vault)
          Rugged::Repository.init_at(vault)
        end
        Rugged::Repository.new(vault)
      end
    end

    def migrate(direction = :up)
      migrations = ActiveRecord::Migration.new.migration_context.migrations
      ActiveRecord::Migrator.new(direction, migrations, nil).migrate
    end

    attr_accessor :logger
    def with_logger(&block)
      previous, @logger = @logger, block
      yield
    ensure
      @logger = previous
    end

    def log(message)
      @logger.call(message)
    end

    def start_daemon
      @daemon_started ||= `docker run --name travis-civic_duty -dit travisci/ci-garnet:packer-1512502276-986baf0  /sbin/init` && true
    end

    def start_shell
      `docker exec -it travis-civic_duty bash -l`
    end


  end
  CivicDuty.logger = method(:puts)
end
