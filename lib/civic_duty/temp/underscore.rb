require_relative '../../civic_duty'

module CivicDuty
  job = FindNodes['(lvar :_)']
  puts job.test(<<-RUBY).summary
def foo(_)
  _, _ = x
  foo { |_| }
  foo(_)
end
  RUBY
end
