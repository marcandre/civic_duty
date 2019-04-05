module CivicDuty
  class FindNodes < Job::Runner
    param :matcher

    step def find_nodes
      each_node(path).select(&matcher)
    end

    def self.[](pattern)
      super(matcher: Matcher::Node.new(pattern))
    end
  end
end
