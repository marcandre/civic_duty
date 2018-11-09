module CivicDuty
  class CountOccurrences < Job::Runner
    param :pattern

    step :count_occurrences
  end
end
