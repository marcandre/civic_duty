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
      CivicDuty.log "Fetching #{folder_name}"
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

    def ready?
      path.exist? && repo.ref(remote_ref)
    end

    def ready
      #checkout! # TODO: Very wrong
      self
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

    def current_commit_hash
      repo.last_commit.oid
    end

    def repo
      begin
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
      "#{base_url}.git"
    end

    def base_url
      "https://#{host}.com/#{owner}/#{name}"
    end

    def path_summary(path:, from: nil, to: nil)
      relative_path = path.relative_path_from(self.path).to_s
      url = "#{base_url}/blob/#{current_commit_hash}/#{relative_path}"
      if from
        url << "#L#{from}"
        url << "-L#{to}" if to
      end
      url
    end
  end

  class BitbucketRepository < GitRepository
    def remote_url
      "https://#{host}.org/#{owner}/#{name}"
    end
  end
end
