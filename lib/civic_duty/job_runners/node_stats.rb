module CivicDuty
  class NodeStats < FindNodes
    param :store_names

    step :find_nodes

    step def get_arg_types
      find_nodes.map do |block_node|
        block_node.arguments.map(&retrieve).sort
      end.tally
    end

    def retrieve
      @retrieve ||= store_names ? -> (arg) { arg.children[0] } : :type
    end
  end
end
