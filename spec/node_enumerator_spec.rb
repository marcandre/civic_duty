require_relative 'spec_helper'

module CivicDuty
  describe NodeEnumerator do
    let(:source) { 'a = "hello"; b = 42' }

    let(:enumerator) { NodeEnumerator.new(source: source) }

    it 'should enumerator all nodes' do
      enumerator.each.map(&:type).should eq %i[begin lvasgn str lvasgn int]
    end
  end
end
