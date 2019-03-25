module CivicDuty
  class Build < Model
    class MarshalColumn
      def dump(obj)
        Marshal.dump obj
      end

      def load(marshal)
        Marshal.load(marshal) if marshal
      end
    end

    belongs_to :task
    enum status: %i[pending running success failure error]
    serialize :result, MarshalColumn.new
    symbol_column :step
  end
end
