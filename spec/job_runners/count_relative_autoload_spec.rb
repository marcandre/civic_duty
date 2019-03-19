require_relative '../spec_helper'

module CivicDuty
  describe CountRelativeAutoload do
    include_context 'job runner'
    subject { task }

    it 'should be a success' do
        puts task.builds.last.output unless task.status == :success
        task.status.should eq :success
    end
    its(:step_result) { should eq({all: 3, relative: 2}) }
  end
end
