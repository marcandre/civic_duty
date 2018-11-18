require_relative '../spec_helper'

module CivicDuty
  RSpec::Matchers.define :match_composition do |*matchers, for_value:|
    match do |klass|
      klass.new(*matchers) === for_value
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
  end
end
