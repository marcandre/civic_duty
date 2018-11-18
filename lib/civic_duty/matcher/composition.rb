module CivicDuty
  module Matcher
    class Composition
      attr_reader :matchers
      def initialize(*matchers)
        @matchers = matchers
      end

      def ===(obj)
        @matchers.send(self.class::COMPOSITION_METHOD) { |m| m === obj }
      end
    end

    class And < Composition
      COMPOSITION_METHOD = :all?
    end

    class Or < Composition
      COMPOSITION_METHOD = :any?
    end

    class One < Composition
      COMPOSITION_METHOD = :one?
    end
  end
end
