module CivicDuty
  class NodeStats < FindNodes
    step :find_nodes

    step def get_arg_types
      find_nodes.map do |block_node|
        block_node.arguments.map(&:type).sort
      end.tally
    end
  end
end
