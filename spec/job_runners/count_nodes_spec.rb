require_relative '../spec_helper'

module CivicDuty
  RSpec.describe CountNodes do
    let(:runner_class) { described_class }
    let(:repository) { ManualRepository.create! name: 'trivial_gem' }
    let(:projects) { Project.create! repository: repository }

    describe 'from a Job created manually' do
      let(:params) { {matcher: Matcher::Send.new(:autoload)} }
      let(:job) { Job.create!(runner_class: runner_class, params: params)
                  .create_tasks_for(projects)
                  .run }
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
