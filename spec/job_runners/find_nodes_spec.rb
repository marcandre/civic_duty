require_relative '../spec_helper'

module CivicDuty
  describe FindNodes do
    include_context 'job runner'

    let(:params) { {matcher: Matcher::Send.new(:autoload)} }
    subject { task }

    its(:status) { should eq :success }
    its(:synthesis) { should eq 3 }
    its(:summary) { should eq <<-SUMMARY }
trivial_gem/lib/trivial_gem.rb:4-4
autoload :BAR, 'trivial_gem/bar'

trivial_gem/lib/trivial_gem.rb:5-5
Object.autoload :FOO, 'trivial_gem/foo.rb'

trivial_gem/lib/trivial_gem.rb:6-6
autoload :JSON, 'json'
    SUMMARY

    describe :test do
      let(:job) { FindNodes['(block _ (args procarg) ...)'] }
      let(:block) { 'bar { |x| }' }
      let(:task) { job.test("def foo; #{block}; end") }
      subject { task.summary }
      it { should include block }
    end
  end
end
