module CivicDuty
  class Matcher::Node < ::RuboCop::NodePattern
    def ===(node)
      match(node) # can't use alias as it's a singleton method
    end
  end
end
