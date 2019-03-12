module CivicDuty
  require_relative_dir

  ::RuboCop::AST::Node.include Ext::Node
  ::RuboCop::NodePattern.prepend Ext::NodePattern
end


