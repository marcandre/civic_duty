require_relative '../spec_helper'

module CivicDuty
  RSpec::Matchers.define :match_composition do |*matchers, for_value:|
    match do |klass|
      klass.new(*matchers) === for_value
    end
  end

  RSpec.describe AndMatcher do
    subject { described_class }
    it { should match_composition /a/, /aa/, for_value: 'aaa' }

    it { should_not match_composition /a/, /bb/, for_value: 'aaa' }

    it { should_not match_composition /b/, /bb/, for_value: 'aaa' }
  end

  RSpec.describe OrMatcher do
    subject { described_class }
    it { should match_composition /a/, /aa/, for_value: 'aaa' }

    it { should match_composition /a/, /bb/, for_value: 'aaa' }

    it { should_not match_composition /b/, /bb/, for_value: 'aaa' }
  end

  RSpec.describe OneMatcher do
    subject { described_class }
    it { should_not match_composition /a/, /aa/, for_value: 'aaa' }

    it { should match_composition /a/, /bb/, for_value: 'aaa' }

    it { should_not match_composition /b/, /bb/, for_value: 'aaa' }
  end
end
