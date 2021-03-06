module CivicDuty
  module Formatting
    def shorten_list(list, ok: 5, cut_to: 3)
      if list.size > ok
        extra = " and #{list.size - cut_to} more"
        list = list.first(cut_to)
      end
      [list, extra]
    end

    def summarize_list(list, ok: 5, cut_to: 3, &block)
      list, extra = shorten_list(list, ok: ok, cut_to: cut_to)
      list.map!(&block) if block
      "#{list.join(", ")}#{extra}"
    end

    def regroup(grouped, ok: 7, merge: 4)
      return grouped if grouped.size <= ok
      n = ((grouped.size - 2).fdiv(merge)).ceil
      grouped = grouped.to_a
      regrouped = grouped[1...-1].each_slice(n).map do |groups|
        indices = groups.map(&:first)
        [indices.first .. indices.last, groups.flat_map(&:last)]
      end
      [
        grouped.first,
        *regrouped,
        grouped.last,
      ]
    end
    extend self
  end
end
