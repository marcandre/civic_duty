module CivicDuty
  class FindNodes < Job::Runner
    param :matcher

    step def find_nodes
      each_node(path).select(&matcher)
    end

    def self.[](pattern)
      super(matcher: Matcher::Node.new(pattern))
    end

    CAP = 3
    def summary
      results = task.step_result
      return 'n/a' if results.size == 0
      remainder = results.size - CAP
      results
        .first(CAP)
        .map { |r| r.summary(&project.repository.method(:path_summary)) }
        .tap { |ary| ary << "and #{remainder} other occurences." if remainder > 0 }
        .join("\n\n")
        .<<("\n")
    end
  end
end
