module CivicDuty
  class Build < Model
    after_save { task.cache_builds! }
    after_destroy { task.cache_builds! }

    class MarshalColumn
      def dump(obj)
        Marshal.dump obj
      end

      def load(marshal)
        Marshal.load(marshal) if marshal
      end
    end

    belongs_to :task, inverse_of: :builds
    enum status: %i[pending running success failure error]
    serialize :result, MarshalColumn.new
    symbol_column :step
  end
end
