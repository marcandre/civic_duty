module CivicDuty
  class Matcher::Not < Struct.new(:matcher)
    def ===(obj)
      !(matcher === obj)
    end
  end
end
