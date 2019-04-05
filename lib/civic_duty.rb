require 'active_record'
require 'require_relative_dir'
require 'libraries_io'
require 'parser/current'
require 'rubocop'
require 'set'

require 'backports/2.6.0/kernel/then'
require 'backports/2.4.0/hash/transform_values'

autoload :Rugged, 'rugged'

module CivicDuty
  require_relative 'civic_duty/load_all'

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
      ::RuboCop::AST::Builder.emit_procarg0 = true
      ::Parser::CurrentRuby.new(::RuboCop::AST::Builder.new).tap do |parser|
        parser.diagnostics.all_errors_are_fatal = false
        parser.diagnostics.ignore_warnings      = true
      end
    end

    def parse(path: nil, source: path.read)
      buffer = ::Parser::Source::Buffer.new(path || '(inline)')
      buffer.source = source
      parser.parse buffer
    end
  end
  CivicDuty.logger = method(:puts)
end
