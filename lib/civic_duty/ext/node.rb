module CivicDuty
  module Ext
    module Node
      def summary(maxlen = 80)
        total = expression.length
        if total > maxlen
          "#{expression[0...(maxlen / 2)]} … #{expression[(maxlen / 2)..-1]}"
        else
          expression
        end
      end
    end
  end
end
