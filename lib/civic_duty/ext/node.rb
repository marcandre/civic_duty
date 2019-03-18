module CivicDuty
  module Ext
    module Node
      def summary(maxlen = 80)
        code = source
        total = code.length
        if total > maxlen
          "#{code[0...(maxlen / 2)]} … #{code[-(maxlen / 2)..-1]}"
        else
          code
        end
      end
    end
  end
end
