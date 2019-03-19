require_relative 'spec_helper'

module CivicDuty
  describe Job do
    include_context 'job runner'
    let(:runner_class) { FindNodes }
    let(:params) { {matcher: Matcher::Send.new(:autoload)} }


    subject { job }

    its(:report) { should == <<-REPORT }
*** Completed: ***
3: trivial_gem

*** Summaries: ***
trivial_gem/lib/trivial_gem.rb:4-4
autoload :BAR, 'trivial_gem/bar'

trivial_gem/lib/trivial_gem.rb:5-5
Object.autoload :FOO, 'trivial_gem/foo.rb'

trivial_gem/lib/trivial_gem.rb:6-6
autoload :JSON, 'json'


    REPORT

    context "with an unfinished job" do
      let(:autorun) { false }

      its(:report) { should == <<-REPORT }
*** Not completed: ***
pending: trivial_gem

*** Completed: ***
None

      REPORT
    end
  end
end
