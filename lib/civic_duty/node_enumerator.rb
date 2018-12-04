module CivicDuty
  class NodeEnumerator
    include Enumerable

    def initialize(path: nil, source: path.read)
      @path = path
      @source = source
    end

    def each(&block)
      return to_enum :each unless block_given?
      process parse, &block
      self
    end

    private def process(node, &block)
      return unless node.is_a? ::AST::Node
      yield node
      node.children.each do |child|
        process(child, &block)
      end
    end

    private def parse
      CivicDuty.parse path: @path, source: @source
    end
  end
end
