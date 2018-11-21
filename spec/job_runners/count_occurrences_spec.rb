require_relative '../spec_helper'

module CivicDuty
  RSpec.describe CountOccurrences do
    let(:runner_class) { described_class }
    let(:params) { {pattern: 'autoload'} }
    let(:repository) { ManualRepository.create! name: 'trivial_gem' }
    let(:projects) { Project.create! repository: repository }
    let(:job) { Job.create!(runner_class: runner_class, params: params)
                .create_tasks_for(projects)
                .run }
    let(:task) { job.tasks.first }
    subject { task }

    its(:status) { should eq :success }
    its(:step_result) { should eq 3 }
  end
end
