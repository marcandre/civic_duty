module CivicDuty
  class Matcher::Any
    def ===(obj)
      true
    end
  end
  ANY = Matcher::Any.new.freeze
end
