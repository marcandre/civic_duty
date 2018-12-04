module CivicDuty
  require_relative 'node'

  module Matcher
    class Send < Node
      def initialize(method_name, receiver: '_')
        super "$({send csend} #{receiver} ...)"
      end
    end
  end
end
