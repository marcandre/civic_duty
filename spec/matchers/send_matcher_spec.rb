require_relative '../spec_helper'

module CivicDuty
  RSpec::Matchers.define :match_send do |name, with_receiver: '_', for_code:|
    match do |klass|
      ast = CivicDuty.parse(source: for_code)
      klass.new(name, receiver: with_receiver) === ast
    end
  end

  describe Matcher::Send do
    subject { described_class }
    it { should match_send :foo, for_code: 'foo' }

    it { should match_send 'foo', for_code: 'foo(42)' }

    it { should match_send :foo, for_code: '42.foo' }

    it { should match_send :foo, for_code: '42&.foo' }

    it { should_not match_send :foo, for_code: 'foo = 42' }

    it { should_not match_send :foo, for_code: ':foo' }

    it { should_not match_send :foo, with_receiver: :nil?, for_code: '42.foo' }

    it { should match_send :foo, with_receiver: :nil?, for_code: 'foo 42' }

    it { should match_send :foo, with_receiver: :nil?, for_code: 'foo 42' }
  end
end
