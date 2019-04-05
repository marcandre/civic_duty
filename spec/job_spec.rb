require_relative 'spec_helper'

module CivicDuty
  describe Job do
    include_context 'job runner'
    let(:runner_class) { FindNodes }
    let(:params) { {matcher: Matcher::Send.new(:autoload)} }


    subject { job }

    its(:report) { should == <<-REPORT }
*** Completed: ***
3 (100 %): trivial_gem
3: total

*** Summaries: ***
* trivial_gem *
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

    context "with an tally-type job" do
      let(:runner_class) { NodeStats }
      let(:params) { {matcher: Matcher::Node.new('block')} }
      before { job.tasks << job.tasks.first.dup }
      its(:report) { should == <<-REPORT }
*** Combined: ***
12 (60 %): []
6 (30 %): [:procarg0]
2 (10 %): [:optarg]
20: total

*** Completed: ***
10 (100 %): trivial_gem, trivial_gem
20: total

*** Summaries: ***
* trivial_gem *
6 (60 %): []
3 (30 %): [:procarg0]
1 (10 %): [:optarg]
10: total
* trivial_gem *
6 (60 %): []
3 (30 %): [:procarg0]
1 (10 %): [:optarg]
10: total

      REPORT
    end

  end

end
