require_relative '../spec_helper'

module CivicDuty
  RSpec::Matchers.define :match_composition do |*matchers, for_value:, &block|
    match do |klass|
      klass.new(*matchers, &block) === for_value
    end
  end

  RSpec.describe Matcher do
    subject { described_class }

    describe Matcher::And do
      it { should match_composition /a/, /aa/, for_value: 'aaa' }

      it { should_not match_composition /a/, /bb/, for_value: 'aaa' }

      it { should_not match_composition /b/, /bb/, for_value: 'aaa' }
    end

    describe Matcher::Or do
      it { should match_composition /a/, /aa/, for_value: 'aaa' }

      it { should match_composition /a/, /bb/, for_value: 'aaa' }

      it { should_not match_composition /b/, /bb/, for_value: 'aaa' }
    end

    describe Matcher::One do
      it { should_not match_composition /a/, /aa/, for_value: 'aaa' }

      it { should match_composition /a/, /bb/, for_value: 'aaa' }

      it { should_not match_composition /b/, /bb/, for_value: 'aaa' }
    end

    describe Matcher::Block do
      it { should match_composition(for_value: 'aaa') do |value| value.should == 'aaa'; true; end }

      it { should_not match_composition(for_value: 'aaa') do |value| value.should == 'aaa'; false; end }
    end
  end
end