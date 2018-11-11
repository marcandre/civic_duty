module CivicDuty
  class CountOccurrences < Job::Runner
    param :matcher

    step :count_nodes
  end
end
