module CivicDuty
  require_relative_dir

  Node = ::RuboCop::AST::Node

  # Shortcut to create a node from source code
  def Node.[](source)
    CivicDuty.parse(source: source)
  end

  Node.include Ext::Node
  ::RuboCop::NodePattern.prepend Ext::NodePattern
  class ::RuboCop::NodePattern
    Compiler.prepend Ext::NodePattern::Compiler
  end

  ::Parser::Source::Buffer.include Ext::SourceBuffer
end


