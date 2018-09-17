module CivicDuty
  class Repository < ActiveRecord::Base
    include Grabbable
    has_many :projects

    def self.from_url(url)
      # TODO: Probably dependent on host. Right now assume github
      m = url.match %r{^https?://(?<host>\w+).com/(?<owner>.+)/(?<name>.+)$}
      raise "Failed to parse repository URL '#{url}'" unless m
      find_or_create_by! m.named_captures
    end

    def libraries_io_data
      CivicDuty.libraries_io_api.repository(owner: owner, name: name, host: host).info
    end
  end
end
