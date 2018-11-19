module CivicDuty
  class CountRelativeAutoload < Job::Runner
    step def count_relative_autoload
      matcher = Matcher::Method.new(:autoload)
      {
        all: count_occurences(matcher),
        relative: count_occurences(matcher.and {|node| is_relative_autoload?(node) }),
      }
    end

    private def is_relative_autoload?(node)
      _receiver, _method, _const, path = node.children
      has_relative_ruby_file?(path, node.location.expression.source_buffer.name)
    end

    private def has_relative_ruby_file?(path, source_path)
      root = find_project_path(source_path)
      return false unless root

      path = Pathname(path)
      path.join('.rb') unless path.extname == '.rb'

      !path.relative_path_from(root).to_s.start_with?('../')
    end

    private def find_project_path(source_path)
      root, lib, = source_path.rpartition('/lib/')
      Pathname(root + lib) unless lib
    end
  end
end
