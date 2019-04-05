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

    def combine_list(object_or_list)
      return object_or_list unless object_or_list.is_a?(Array)
      object_or_list.first .. object_or_list.last
    end

    def regroup(grouped, ok: 7, merge: 4, top: 1, bottom: 1)
      return grouped if grouped.size <= ok
      n = ((grouped.size - top - bottom).fdiv(merge)).ceil
      grouped = grouped.to_a
      regrouped = grouped[top..-(1+bottom)].each_slice(n).map do |groups|
        indices, values = groups.transpose
        indices = indices[0] if indices.size == 1
        [indices, values.reverse.flatten(1)]
      end
      [
        *grouped.first(top),
        *regrouped,
        *grouped.last(bottom),
      ]
    end

    def ratio(value, total)
      percent = value * 100.fdiv(total)
      round_to = case percent
      when 3..100
        0
      when 1..3
        1
      when 0..1
        2
      end
      "#{percent.round(round_to)} %"
    end

    extend self
  end
end
