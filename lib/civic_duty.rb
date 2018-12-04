require 'active_record'
require 'require_relative_dir'
require 'libraries_io'
require 'parser/current'
require 'set'

autoload :Rugged, 'rugged'

module CivicDuty
  extend RequireRelativeDir
  require_relative 'civic_duty/model'
  require_relative_dir 'civic_duty/models'

  require_relative_dir 'civic_duty/step_helpers'
  require_relative 'civic_duty/job_runner'
  require_relative_dir 'civic_duty/job_runners'
  require_relative_dir 'civic_duty'

  DEFAULT_VAULT_REPOSITORY_REPO_PATH = './vault'
  DEFAULT_DB_PATH = "#{DEFAULT_VAULT_REPOSITORY_REPO_PATH}/.vault.sqlite3"

  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || "sqlite3:#{DEFAULT_DB_PATH}")

  class << self
    def libraries_io_api
      @libraries_io_api ||= LibrariesIO.new(per_page: 100)
    end

    def vault_path
      @vault ||= begin
        p = Pathname(ENV['VAULT_REPOSITORY'] || DEFAULT_VAULT_REPOSITORY_REPO_PATH)
        p.mkdir unless p.exist?
        p
      end
    end

    def migrate(direction = :up)
      migrations = ActiveRecord::Migration.new.migration_context.migrations
      migrations = [migrations.last] if direction == :down
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

    def parser
      ::Parser::CurrentRuby.new.tap do |parser|
        parser.diagnostics.all_errors_are_fatal = false
        parser.diagnostics.ignore_warnings      = true
      end
    end

    def parse(path: nil, source: path.read)
      buffer = ::Parser::Source::Buffer.new(path || '')
      buffer.source = source
      parser.parse buffer
    end
  end
  CivicDuty.logger = method(:puts)
end
