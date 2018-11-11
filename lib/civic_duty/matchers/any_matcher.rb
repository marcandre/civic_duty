module CivicDuty
  class AnyMatcher
    def ===(obj)
      true
    end
  end
  ANY = AnyMatcher.new.freeze
end
