module CivicDuty
  class NotMatcher < Struct(:matcher)
    def ===(obj)
      matcher !== obj
    end
  end
end
