module CivicDuty
  class CountNodes < Job::Runner
    param :matcher

    step def count_nodes
      super(path, &matcher)
    end

    def self.[](pattern)
      super(matcher: Matcher::Node.new(pattern))
    end
  end
end
