require_relative '../spec_helper'

module CivicDuty
  record = ENV['R'] ? :new_episodes : :none

  RSpec.describe Project, vcr: {record: record, cassette_name: 'shared'} do
    let(:project) { Project.from_name('deep-cover-core') }
    subject { project }

    its(:persisted?) { should == true }

    its(:grabbed?) { should == false }

    its(:dependents) { should be_empty }

    its(:dependencies) { should be_empty }

    its(:name) { should == 'deep-cover-core' }

    describe 'when grabbed' do
      subject { project.grabbed }

      its(:dependent_projects) { should include(have_attributes(
        name: 'deep-cover',
        grabbed?: false,
      )) }

      its(:project_dependencies) { should include(have_attributes(
        name: 'parser',
        grabbed?: false,
      )) }
    end

    describe 'when grabbed recursively' do
      # @cache it so it is processed only once...
      let(:processed) { @processed_cached ||= [] }
      let!(:grabbed) { @cache ||= project.grabbed(depth: 1) do |project, kind: , of:, depth: |
        processed << project.name
      end.freeze }
      subject { grabbed }

      its(:dependent_projects) { should include(have_attributes(
        name: 'deep-cover',
        grabbed?: true,
      )) }

      its(:project_dependencies) { should include(have_attributes(
        name: 'parser',
        grabbed?: true,
      )) }

      it 'yields projects and other information' do
        expect(processed).to include(*%w[deep-cover parser backports rubocop])
      end
    end

    describe 'default_set and top' do
      subject { Project.default_set }
      its(:count) { should == 0 }

      describe 'with a project loaded' do
        before { project.grabbed }
        its(:count) { should == 1 }
      end
    end
  end
end
