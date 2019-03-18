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
    end
  end
end
