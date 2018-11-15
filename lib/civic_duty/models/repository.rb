module CivicDuty
  require_relative 'grabbable'

  class Repository < Model
    include Grabbable
    has_many :projects

    class << self

      def from_url(url)
        return nil if url.empty?
        # TODO: Dependent on host. Right now assume github
        m = url.match %r{^https?://(?<host>\w+).\w+/(?<owner>.+)/(?<name>.+)$}
        raise "Failed to parse repository URL '#{url}'" unless m
        factory = CivicDuty.const_get "#{m[:host].capitalize}Repository"
        factory.find_or_create_by! m.named_captures
      end
    end

    def libraries_io_data
      CivicDuty.libraries_io_api.repository(owner: owner, name: name, host: host).info
    end

    def folder_name
      name == owner ? name : "#{name}.#{owner}"
    end

    def to_s
      "#<#{self.class} '#{folder_name}'>"
    end
  end
end
