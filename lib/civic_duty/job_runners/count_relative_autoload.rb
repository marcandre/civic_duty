module CivicDuty
  class CountRelativeAutoload < Job::Runner
    step def count_relative_autoload
      matcher = Matcher::Send.new(:autoload)
      {
        all:      count_nodes(path, &matcher),
        relative: count_nodes(path, &matcher.and {|node| is_relative_autoload?(node) }),
      }
    end

    private def is_relative_autoload?(node)
      _receiver, _method, _const, path_node = node.children
      return false unless path_node.type == :str
      path = Pathname(path_node.children.first)
      has_relative_ruby_file?(path, node.location.expression.source_buffer.name)
    end

    private def has_relative_ruby_file?(path, source_path)
      root = find_project_path(source_path)
      return false unless root

      path = Pathname("#{path}.rb") unless path.extname == '.rb'
      root.join(path).exist?
    end

    private def find_project_path(source_path)
      root, lib, = source_path.rpartition('/lib/')
      Pathname(root + lib) if lib
    end
  end
end
