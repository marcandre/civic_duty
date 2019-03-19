require_relative '../spec_helper'

module CivicDuty
  RSpec.describe FindNodes do
    include_context 'job runner'

    let(:params) { {matcher: Matcher::Send.new(:autoload)} }
    subject { task }

    its(:status) { should eq :success }
    its(:synthesis) { should eq 3 }
    its(:summary) { should eq <<-SUMMARY }
trivial_gem/lib/trivial_gem.rb:4-4
autoload :BAR, 'trivial_gem/bar'

trivial_gem/lib/trivial_gem.rb:5-5
Object.autoload :FOO, 'trivial_gem/foo.rb'

trivial_gem/lib/trivial_gem.rb:6-6
autoload :JSON, 'json'
    SUMMARY
  end
end
