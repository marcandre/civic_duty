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
        binding.pry
        raise ArgumentError, "expected a block of arity one" unless block && block.arity == 1
        @block = block
      end
      def ===(obj)
        @block.call(obj)
      end
    end

    def and(*matchers, &block)
      matchers.push(Block.new(&block)) if block
      And.new(*matchers)
    end

    def or(*matchers, &block)
      matchers.push(Block.new(&block)) if block
      Or.new(*matchers)
    end
  end
end
