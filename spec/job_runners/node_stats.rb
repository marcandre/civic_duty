require_relative '../spec_helper'

module CivicDuty
  describe FindNodes do
    let(:job) { NodeStats['block'] }
    let(:source) { <<-RUBY }
      foo { |x| }
      bar { |x, y| }
      baz { }
      baz2 { }
    RUBY
    let(:task) { job.test(source) }
    subject { task }

    its(:summary) { should eq <<-SUMMARY.strip }
[]: 2
[:arg, :arg]: 1
[:procarg0]: 1
    SUMMARY
  end
end
