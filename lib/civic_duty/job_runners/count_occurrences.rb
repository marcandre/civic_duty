module CivicDuty
  class CountOccurrences < Job::Runner
    param :pattern

    step :count_occurrences, :pattern
  end
end
