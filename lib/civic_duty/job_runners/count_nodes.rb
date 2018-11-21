module CivicDuty
  class CountNodes < Job::Runner
    param :matcher

    step def count_nodes
      super(path, &matcher)
    end
  end
end
