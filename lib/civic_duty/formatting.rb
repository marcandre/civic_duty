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
      "#{list.map(&:to_s).join(", ")}#{extra}"
    end

    def regroup(grouped, ok: 7, merge: 4, top: 1, bottom: 1)
      return grouped if grouped.size <= ok
      n = ((grouped.size - top - bottom).fdiv(merge)).ceil
      grouped = grouped.to_a
      regrouped = grouped[top..-(1+bottom)].each_slice(n).map do |groups|
        indices = groups.map(&:first)
        [indices.first .. indices.last, groups.map(&:last).reverse.flatten(1)]
      end
      [
        *grouped.first(top),
        *regrouped,
        *grouped.last(bottom),
      ]
    end
    extend self
  end
end
