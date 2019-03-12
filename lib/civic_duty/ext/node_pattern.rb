module CivicDuty
  module Ext
    module NodePattern
      attr_reader :pattern

      def initialize(str)
        @pattern = str
        super
      end

      def match(*args)
        # If we're here, it's because the singleton method has not been defined,
        # either because we've been dup'ed or serialized through YAML
        initialize(pattern)
        match(*args)
      end

      def marshal_load(pattern)
        initialize pattern
      end

      def marshal_dump
        pattern
      end

      def to_s
        "#<#{self.class} #{pattern}>"
      end
    end
  end
end
