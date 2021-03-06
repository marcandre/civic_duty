require_relative '../spec_helper'

module CivicDuty
  describe ::RuboCop::AST::Node do
    let(:source) { '42.to_s' }
    let(:node) { CivicDuty.parse(source: source) }
    subject { node }

    describe '#summary' do
      its(:summary) { should == source }

      describe 'for a long source' do
        let(:source) { "hello = [#{(1..40).to_a.join(', ')}]"}
        its(:summary) { should == 'hello = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,  …  31, 32, 33, 34, 35, 36, 37, 38, 39, 40]' }
      end

      describe 'with a path formatter block' do
        let(:source) { "foo\nbar"}
        let(:summary) { node.summary { |path: , from: , to: | "#{path}:#{from}-#{to}" } }
        subject { summary }
        it { should == "(inline):1-2\nfoo\nbar" }
      end

    end
  end
end
