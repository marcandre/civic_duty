require_relative '../spec_helper'

module CivicDuty
  RSpec.describe CountRelativeAutoload do
    let(:runner_class) { described_class }
    let(:repository) { ManualRepository.create! name: 'trivial_gem' }
    let(:projects) { Project.create! repository: repository }
    let(:job) { Job.create!(runner_class: runner_class)
                .create_tasks_for(projects)
                .run }
    let(:task) { job.tasks.first }
    subject { task }

    it 'should be a success' do
        puts task.builds.last.output unless task.status == :success
        task.status.should eq :success
    end
    its(:step_result) { should eq({all: 3, relative: 2}) }
  end
end
