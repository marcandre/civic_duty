module CivicDuty
  require_relative 'node'

  module Matcher
    class Send < Struct.new(:method_name, :receiver)
      delegate :===, to: :@node_matcher

      def initialize(method_name, receiver: '_')
        super(method_name, receiver)
        @node_matcher = Matcher::Node.new "$({send csend} #{receiver} :#{method_name} ...)"
      end
    end
  end
end
