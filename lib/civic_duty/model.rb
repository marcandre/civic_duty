module CivicDuty
  class Model < ActiveRecord::Base
    self.abstract_class = true

    class << self
      def symbol_column(column)
        class_eval <<-EVAL, __FILE__, __LINE__ + 1
          def #{column}
            super.to_sym
          end
        EVAL
      end

      def enum(**e)
        column, = e.first
        symbol_column(column)
        super
      end
    end
  end
end
