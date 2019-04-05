module CivicDuty
  class Summarizer < Struct.new(:results, :path_summary_block)
    def summary
      case result_type
      when [], {}, NilClass
        'n/a'
      when [Node]
        nodes_summary
      when {Object => Integer}
        tally_summary
      else
        results
      end
    end

    def synthesis
      case result_type
      when [], {}, NilClass
        0
      when [Node]
        results.size
      when {Object => Integer}
        results
      else
        nil
      end
    end

    def result_type
      case results
      when Array
        return [] if results.empty?
        return [Node] if results.all?(Node)
      when Hash
        return {} if results.empty?
        return {Object => Integer} if results.values.all?(Integer)
      end
      results.class
    end

    CAP_NODES = 3
    def nodes_summary
      remainder = results.size - CAP_NODES
      results
        .first(CAP_NODES)
        .map { |r| r.summary(&path_summary_block) }
        .tap { |ary| ary << "and #{remainder} other occurences." if remainder > 0 }
        .join("\n\n")
        .<<("\n")
    end

    def tally_summary
      results
        .sort_by{|key, nb| [-nb, key]}
        .map { |key, value| "#{key}: #{value}" }
        .join("\n")
    end
  end
end
