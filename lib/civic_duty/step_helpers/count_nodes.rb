module CivicDuty
  module StepHelpers
    def count_nodes(dir, &matcher)
      each_ruby_file(dir).sum do |path|
        NodeEnumerator.new(path: path).each.count(&matcher)
      end
    end

    private def each_ruby_file(dir, &block)
      return to_enum :each_ruby_file, dir unless block_given?
      Pathname.glob(dir.join('**/*.rb'), &block)
    end
  end
end

# matcher: Matcher::Node.new(type: [:send, :csend], 0 => nil, 1 => :autoload)
