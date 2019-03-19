module CivicDuty
  shared_context 'job runner' do
    let(:runner_class) { described_class }
    let(:params) { {} }
    let(:repository) { ManualRepository.create! name: 'trivial_gem' }
    let(:projects) { Project.create! repository: repository, name: repository.name }
    let(:autorun) { true }
    let(:job) { Job.create!(runner_class: runner_class, params: params)
                .create_tasks_for(projects)
                .tap { |job| job.run if autorun } }
    let(:task) { job.tasks.first }
  end
end
