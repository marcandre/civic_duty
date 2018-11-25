module CivicDuty
  require_relative 'node'

  module Matcher
    class Send < Node
      def initialize(method_name, receiver: ANY)
        super(
          type: Set[:send, :csend],
          receiver_0: receiver,
          method_1: method_name.to_sym,
        )
      end
    end
  end
end
