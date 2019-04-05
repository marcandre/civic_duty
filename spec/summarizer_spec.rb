require_relative 'spec_helper'

module CivicDuty
  describe Summarizer do
    let(:summarizer) { described_class.new(results) }
    subject { summarizer }

    context "for tally-like results" do
      context "that are simple" do
        let(:results) { {foo: 1, bar: 1, baz: 2} }
        its(:summary) { should == <<-SUMMARY.strip }
2: baz
1: bar, foo
        SUMMARY
      end

      context "with many common items" do
        let(:results) { (1..26).to_h { |i| [i, 42] }.merge(foo: 666) }
        its(:summary) { should == <<-SUMMARY.strip }
666: foo
42: 1, 2, 3 and 23 more
        SUMMARY
      end

      context "with many results" do
        let(:results) { (1..26).to_h { |i| [i, i] } }
        its(:summary) { should == <<-SUMMARY.strip }
26: 26
20..25: 20, 21, 22 and 3 more
14..19: 14, 15, 16 and 3 more
8..13: 8, 9, 10 and 3 more
2..7: 2, 3, 4 and 3 more
1: 1
        SUMMARY
        its(:synthesis) { should == results }
      end
    end
  end
end
