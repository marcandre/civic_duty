require_relative 'spec_helper'

module CivicDuty
  describe Summarizer do
    let(:summarizer) { described_class.new(results) }
    subject { summarizer }

    context "for tally-like results" do
      context "that are simple" do
        let(:results) { {foo: 1, bar: 1, baz: 2} }
        its(:summary) { should == <<-SUMMARY.strip }
2 (50 %): baz
1 (50 %): bar, foo
4: total
        SUMMARY
      end

      context "with many common items" do
        let(:results) { (1..26).to_h { |i| [i, 42] }.merge(foo: 666) }
        its(:summary) { should == <<-SUMMARY.strip }
666 (38 %): foo
42 (62 %): 1, 2, 3 and 23 more
1758: total
        SUMMARY
      end

      context "with many results" do
        let(:results) { (1..26).to_h { |i| [i, i] } }
        its(:summary) { should == <<-SUMMARY.strip }
26 (7 %): 26
20..25 (38 %): 25, 24, 23 and 3 more
14..19 (28 %): 19, 18, 17 and 3 more
8..13 (18 %): 13, 12, 11 and 3 more
2..7 (8 %): 7, 6, 5 and 3 more
1 (0.28 %): 1
351: total
        SUMMARY
        its(:synthesis) { should == results }
        its(:sorted_tally_values) { should == [*1..26].reverse}
      end
    end
  end
end
