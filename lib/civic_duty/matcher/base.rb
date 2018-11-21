module CivicDuty
  module Matcher
    def to_proc
      method(:===).to_proc
    end
  end
end
