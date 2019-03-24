require_relative '../spec_helper'

module CivicDuty
  describe ::Parser::Source::Buffer do
    # Make sure this file isn't ascii only: olé
    let(:node) { CivicDuty.parse(path: Pathname(__FILE__)) }
    let(:buffer) { node.location.expression.source_buffer }

    it 'can be YAML dumped even for non-ascii files' do
      copy = YAML.load(YAML.dump(buffer))
      copy.name.should == buffer.name
      copy.source.should == buffer.source
    end
  end
end
