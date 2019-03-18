require_relative '../spec_helper'

module CivicDuty
  RSpec.describe FindNodes do
    let(:runner_class) { described_class }
    let(:params) { {matcher: Matcher::Send.new(:autoload)} }
    let(:repository) { ManualRepository.create! name: 'trivial_gem' }
    let(:projects) { Project.create! repository: repository }
    let(:job) { Job.create!(runner_class: runner_class, params: params)
                .create_tasks_for(projects)
                .run }
    let(:task) { job.tasks.first }
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
  end
end
