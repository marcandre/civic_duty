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

    private def parser
      ::Parser::CurrentRuby.new.tap do |parser|
        parser.diagnostics.all_errors_are_fatal = false
        parser.diagnostics.ignore_warnings      = true
      end
    end

    private def parse
      buffer = ::Parser::Source::Buffer.new(@path || '')
      buffer.source = @source
      ast = parser.parse buffer
    end
  end
end
