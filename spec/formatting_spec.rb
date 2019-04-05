require_relative 'spec_helper'

module CivicDuty
  describe Formatting do
    describe :summarize_list do
      subject { Formatting.summarize_list(list) }
      context "on a short list" do
        let(:list) { [:a, :b, :c, :d, :e] }
        it { should == "a, b, c, d, e" }
      end

      context "on a long list" do
        let(:list) { (1..10).to_a }
        it { should == "1, 2, 3 and 7 more" }
      end
    end

    describe :regroup do
      let(:grouped) { {a: [1, 2], b: [3], c: [4, 5], d: [7], e: [8]} }
      let(:merged) { Formatting.regroup(grouped, ok: 2, merge: 2) }
      subject { merged }

      its(:first) { should == grouped.to_a.first }

      its(:last) { should == grouped.to_a.last }

      it { merged[1...-1].to_h.should == {
        [:b, :c] => [4, 5, 3],
        [:d] => [7],
      } }
    end
  end
end
