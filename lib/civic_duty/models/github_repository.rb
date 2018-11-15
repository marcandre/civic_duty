module CivicDuty
  require_relative 'repository'

  class GitRepository < Repository
    def remote_name
      'origin'
    end

    # Repository methods (move somewhere else?)
    def reset!
      fetch&.create_branch(force: true)
    end

    def fetch
      CivicDuty.log "Fetching #{owner}/#{name}"
      remote.fetch(remote_main_branch_name)
      self
    end

    def checkout!
      repo.checkout(branch_name, force: true)
      self
    end

    def branch
      repo.branches[branch_name] || create_branch
    end

    def create_branch(**o)
      repo.branches.create(branch_name, remote_ref, **o)
      self
    end

    def branch_name
      'master'
    end

    def remote_main_branch_name
      'master'
    end

    def remote_ref
      "refs/remotes/#{remote_name}/#{remote_main_branch_name}"
    end

    def ok?
      path.exist? && repo.ref(remote_ref)
    end

    def path
      CivicDuty.vault_path.join folder_name
    end

    def remote
      repo.remotes[remote_name] || repo.remotes.create(remote_name, remote_url)
    end

    def remote_url
      raise NotImplemented
    end

    def repo
      @repo ||= begin
        unless path.exist?
          path.mkdir
          Rugged::Repository.init_at(path.to_s) # TODO: https://github.com/libgit2/rugged/pull/769
        end
        Rugged::Repository.new(path.to_s)
      end
    end
  end

  class GithubRepository < GitRepository
    def remote_url
      "https://#{host}.com/#{owner}/#{name}.git"
    end
  end

  class BitbucketRepository < GitRepository
    def remote_url
      "https://#{host}.org/#{owner}/#{name}"
    end
  end
end
