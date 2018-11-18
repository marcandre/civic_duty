module CivicDuty
  class CompositionMatcher
    attr_reader :matchers
    def initialize(*matchers)
      @matchers = matchers
    end

    def ===(obj)
      @matchers.send(self.class::COMPOSITION_METHOD) { |m| m === obj }
    end
  end

  class AndMatcher < CompositionMatcher
    COMPOSITION_METHOD = :all?
  end

  class OrMatcher < CompositionMatcher
    COMPOSITION_METHOD = :any?
  end

  class OneMatcher < CompositionMatcher
    COMPOSITION_METHOD = :one?
  end
end
