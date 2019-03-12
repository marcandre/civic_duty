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

    class Block
      def initialize(&block)
        raise ArgumentError, "expected a block" unless block
        raise ArgumentError, "invalid arity #{block.arity}" unless block.arity == 1 || block.arity <= -1
        @block = block
      end
      def ===(obj)
        @block.call(obj)
      end
    end

    def and(*matchers, &block)
      matchers.push(Block.new(&block)) if block
      And.new(self, *matchers)
    end

    def or(*matchers, &block)
      matchers.push(Block.new(&block)) if block
      Or.new(self, *matchers)
    end
  end
end
