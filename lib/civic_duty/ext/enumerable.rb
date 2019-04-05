module Enumerable
  def tally
    group_by(&:itself).transform_values(&:length)
  end unless method_defined? :tally
end
