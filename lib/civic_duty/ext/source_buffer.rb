module CivicDuty
  module Ext
    module SourceBuffer
      def encode_with coder
        coder['name'] = @name
        coder['first_line'] = @first_line
        coder['source'] = @source
      end

      def init_with coder
        initialize(coder['name'], coder['first_line'])
        self.source = coder['source']
      end
    end
  end
end

