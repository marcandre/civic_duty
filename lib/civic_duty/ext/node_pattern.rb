module CivicDuty
  module Ext
    module NodePattern
      module Compiler
        def compile_nodetype(cur_node, type)
          "(#{cur_node}.is_a?(RuboCop::AST::Node) && #{cur_node}.#{type.tr('-', '_')}_type?)"
        end
      end
    end
  end
end
