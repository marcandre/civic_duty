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
      when :none
        'n/a'
      when :node_list
        nodes_summary
      when :tally
        tally_summary
      else
        results
      end
    end

    def synthesis
      case result_type
      when :none
        0
      when :node_list
        results.size
      when :tally
        results
      else
        nil
      end
    end

    def result_type
      case results
      when Array
        return :none if results.empty?
        return :node_list if results.all?(Node)
      when Hash
        return :none if results.empty?
        return :tally if results.values.all?(Integer)
      end
      :misc
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

    def sorted_tally_values
      organized_tally.flat_map { |_nb, objects| objects }
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
