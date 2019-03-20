module CivicDuty
  module Ext
    module Node
      def summary(maxlen = 80)
        code = source
        total = code.length
        range = location.expression
        path_summary = yield(
          path: Pathname(range.source_buffer.name),
          from: range.line,
          to: range.last_line
        ) if block_given?

        code = "#{code[0...(maxlen / 2)]} … #{code[-(maxlen / 2)..-1]}" if total > maxlen
        [path_summary, code].compact.join("\n")
      end

      # Search self and descendants for a particular Class or type
      def find_all(lookup)
        case lookup
        when ::Module
          each_node.grep(lookup)
        when ::Symbol
          each_node.find_all { |n| n.type == lookup }
        when ::String
          matcher = Matcher::Node.new(lookup)
          each_node.find_all { |n| matcher === n }
        when ::Regexp
          each_node.find_all { |n| n.source =~ lookup }
        else
          raise ::TypeError, "Expected class or symbol, got #{lookup.class}: #{lookup.inspect}"
        end
      end

      # Shortcut to access children
      def [](lookup)
        if lookup.is_a?(Integer)
          children.fetch(lookup)
        else
          found = find_all(lookup)
          case found.size
          when 1
            found.first
          when 0
            raise "No children of type #{lookup}"
          else
            raise "Ambiguous lookup #{lookup}, found #{found}."
          end
        end
      end

      # Yields its children and itself
      def each_node(&block)
        return to_enum :each_node unless block_given?
        children_nodes.each do |child|
          child.each_node(&block)
        end
        yield self
        self
      end
    end
  end
end
