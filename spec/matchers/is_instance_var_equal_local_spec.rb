require_relative '../spec_helper'

module CivicDuty
  describe Matcher::InstanceVarEqualLocal do
    let(:method_name) { :initialize }
    let(:body) { "@a = a"}
    let(:source) { <<-RUBY }
      def #{method_name}(a, b, c: 42)
        #{body}
      end
    RUBY
    let(:matcher) { described_class.new }
    subject { NodeEnumerator.new(source: source).each.count(&matcher) }


    describe 'locates a simple assigment' do
      it { should == 1 }
    end

    describe 'ignores an assignment to mismatching local variables' do
      let(:body) { "@b = c + c"}
      it { should == 0 }
    end

    describe 'ignores an assignment to expressions' do
      let(:body) { "@b = c + c"}
      it { should == 0 }
    end

    describe Matcher::InstanceVarEqualLocal::InInitialize do
      describe 'ignores simple assigment outside of initialize' do
        let(:method_name) { :foo }
        it { should == 0 }
      end

      describe 'locates an assignment to a keyword variable' do
        let(:body) { "@c = c"}
        it { should == 1 }
      end

      describe 'ignores an assignment to local variable that is not an argument' do
        let(:body) { "foo = 42; @foo = foo"}
        it { should == 0 }
      end
    end
  end
end
