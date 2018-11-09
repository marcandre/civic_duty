module CivicDuty
  class Build < Model
    belongs_to :task
    enum status: %i[pending running success failure error]
    serialize :result
    symbol_column :step
  end
end
