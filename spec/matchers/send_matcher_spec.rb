require_relative '../spec_helper'

module CivicDuty
  RSpec::Matchers.define :match_send do |name, with_receiver: ANY, for_code:|
    match do |klass|
      klass.new(name, receiver: with_receiver) === ::Parser::CurrentRuby.parse(for_code)
    end
  end

  RSpec.describe Matcher::Send do
    subject { described_class }
    it { should match_send :foo, for_code: 'foo' }

    it { should match_send 'foo', for_code: 'foo(42)' }

    it { should match_send :foo, for_code: '42.foo' }

    it { should match_send :foo, for_code: '42&.foo' }

    it { should_not match_send :foo, for_code: 'foo = 42' }

    it { should_not match_send :foo, for_code: ':foo' }

    it { should_not match_send :foo, with_receiver: nil, for_code: '42.foo' }

    it { should match_send :foo, with_receiver: nil, for_code: 'foo 42' }

    it { should match_send :foo, with_receiver: nil, for_code: 'foo 42' }
  end
end
