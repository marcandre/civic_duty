module CivicDuty
  class Repository < ActiveRecord::Base
    include Grabbable
    has_many :projects

    def self.from_url(url)
      return nil if url.empty?
      # TODO: Probably dependent on host. Right now assume github
      m = url.match %r{^https?://(?<host>\w+).com/(?<owner>.+)/(?<name>.+)$}
      raise "Failed to parse repository URL '#{url}'" unless m
      find_or_create_by! m.named_captures
    end

    def libraries_io_data
      CivicDuty.libraries_io_api.repository(owner: owner, name: name, host: host).info
    end

    def remote_name
      "#{name}.#{owner}"
    end

    def to_s
      "#<CivicDuty::Repository '#{remote_name}'>"
    end

    def remote_url
      # TODO: Probably dependent on host. Right now assume github
      "https://#{host}.com/#{owner}/#{name}.git"
    end

    # Repository methods (move somewhere else?)
    def reset!
      CivicDuty.log "Fetching #{owner}/#{name}"
      remote.fetch(remote_main_branch_name)
      create_branch(force: true)
    end

    def checkout!
      repo.checkout(branch_name, force: true)
    end

    def remote
      repo.remotes[remote_name] || repo.remotes.create(remote_name, remote_url)
    end

    def branch
      repo.branches[branch_name] || (remote.fetch(remote_main_branch_name); create_branch)
    end

    def create_branch(**o)
      repo.branches.create(remote_name, remote_source, **o)
    end

    def branch_name
      remote_name
    end

    def remote_main_branch_name
      # TODO: Support others
      'master'
    end

    def remote_source
      "#{remote_name}/#{remote_main_branch_name}"
    end

    private def repo
      CivicDuty.repo
    end
  end
end
