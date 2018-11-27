module CivicDuty
  module Matcher
    class InstanceVarEqualLocal
      def ===(node)
        ivar, var = Matcher::Node.new("(ivasgn $_ivar (lvar $_var))").match(node)

        return false unless ivar && ivar == :"@#{var}"

        loop do
          node = node.parent
          case node.type
          when :def
            return check_def(node, var)
          when :begin, :rescue,  :ensure
            # ignore
          else # If we get to the top, or encounter an if/etc.., reject this
            return false
          end
        end
      end

      def check_def(def_node, var_name)
        local_arguments = def_node.arguments.flat_map do |arg|
          Matcher::Node.new('{(arg $_) (optarg $_ _) (kwarg $_) (kwoptarg $_ _) (kwrestarg $_)}').match(arg)
        end
        local_arguments.include? var_name
      end

      class InInitialize < self
        def check_def(def_node, _)
          def_node.method_name == :initialize && super
        end
      end
    end


  end
end
