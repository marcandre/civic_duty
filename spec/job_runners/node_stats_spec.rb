require_relative '../spec_helper'

module CivicDuty
  describe FindNodes do
    let(:job) { NodeStats['block'] }
    let(:source) { <<-RUBY }
      foo { |x| }
      bar { |y, x| }
      baz { }
      baz2 { }
    RUBY
    let(:task) { job.test(source) }
    subject { task }

    its(:summary) { should eq <<-SUMMARY.strip }
2 (50 %): []
1 (50 %): [:arg, :arg], [:procarg0]
4: total
    SUMMARY

    its(:synthesis) { should eq({
      [] => 2,
      [:arg, :arg] => 1,
      [:procarg0] => 1,
    }) }

    context 'with store_names enabled' do
      let(:job) { NodeStats['(block _ (args arg arg) _)', store_names: true] }

      its(:synthesis) { should eq({
        [:x, :y] => 1,
      }) }
    end
  end
end
