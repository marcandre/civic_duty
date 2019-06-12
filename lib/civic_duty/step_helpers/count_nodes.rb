module CivicDuty
  module StepHelpers

    def count_nodes(dir, &matcher)
      each_node(dir).count(&matcher)
    end

    def each_node(dir, &block)
      return to_enum __method__, dir unless block_given?
      each_ruby_file(dir) do |path|
        NodeEnumerator.new(path: path).each(&block)
      end
    end

    private def each_ruby_file(dir, &block)
      return to_enum __method__, dir unless block_given?
      Pathname.glob(dir.join('**/*.rb')).select(&:file?).sort
      .each(&block)
      self
    end
  end
end

# matcher: Matcher::Node.new(type: [:send, :csend], 0 => nil, 1 => :autoload)
