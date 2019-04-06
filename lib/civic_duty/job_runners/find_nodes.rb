module CivicDuty
  class FindNodes < Job::Runner
    param :matcher

    step def find_nodes
      each_node(path).select(&matcher)
    end

    class << self
      def [](pattern, **options)
        super(matcher: Matcher::Node.new(pattern), **options)
      end
    end
  end
end
