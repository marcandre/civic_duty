require_relative '../spec_helper'

module CivicDuty
  describe CountOccurrences do
    include_context 'job runner'
    let(:params) { {pattern: 'autoload'} }
    subject { task }

    its(:status) { should eq :success }
    its(:step_result) { should eq 3 }
  end
end
