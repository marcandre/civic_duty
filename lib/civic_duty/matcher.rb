module CivicDuty
  module Matcher
  end

  require_relative_dir

  Matcher.constants.each do |const|
    Matcher.const_get(const).include Matcher
  end
end


