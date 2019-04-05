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
        :d => [7],
      } }

      context 'for a tally' do
        let(:grouped) { {0 => %w[ø], 1 => %w[a b], 2 => %w[c d e], 3 => %w[f]} }
        let(:merged) { Formatting.regroup(grouped, merge: 2, ok: 0, top: 1, bottom: 0, sum: true) }

        it { should == [
          [     0, 0, %w[ø]],
          [[1, 2], 8, %w[c d e a b]],
          [     3, 3, %w[f]],
        ] }
      end
    end

    describe :ratio do
      {
        3.666 => "4 %",
        1.666 => "1.7 %",
        0.666 => "0.67 %"
      }.each do |val, expected|
        it "formats #{val} to #{expected}" do
          Formatting.ratio(val, 100).should == expected
        end
      end
    end
  end
end
