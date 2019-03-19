require_relative '../spec_helper'

module CivicDuty
  describe CountNodes do
    include_context 'job runner'

    describe 'from a Job created manually' do
      let(:params) { {matcher: Matcher::Send.new(:autoload)} }
      let(:task) { job.tasks.first }
      subject { task }

      it 'should be a success' do
        puts task.builds.last.output unless task.status == :success
        task.status.should eq :success
      end
      its(:step_result) { should eq 3 }
    end

    describe '.[]' do
      before { projects }
      let(:job) { runner_class['(int)'] }
      subject { job }

      its(:params) { should == {matcher: Matcher::Node.new('(int)')} }

      it 'creates the job and assigns it to default_set' do
        job.tasks.map(&:project).should =~ Project.default_set
      end

      its(:id) { should == runner_class['(int)'].id }
    end
  end
end
