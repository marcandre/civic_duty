module CivicDuty
  class Summarizer
    include Formatting

    attr_reader :results, :path_to_s, :object_to_s

    def initialize(results, path_to_s: nil, object_to_s: nil)
      @results = results
      @path_to_s = path_to_s
      @object_to_s = object_to_s
    end

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
        .map { |r| r.summary(&path_to_s) }
        .tap { |ary| ary << "and #{remainder} other occurences." if remainder > 0 }
        .join("\n\n")
        .<<("\n")
    end

    def tally_summary
      organized_tally
        .map { |nb, objects| "#{nb}: #{summarize_list(objects, &object_to_s)}" }
        .join("\n")
    end

    private def organized_tally
      regroup(
        results
          .group_by { |obj, nb| nb }
          .transform_values { |obj_nb_pairs| obj_nb_pairs.map(&:first).sort }
          .sort
      )
        .reverse
    end
  end
end
