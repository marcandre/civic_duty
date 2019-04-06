require_relative '../../civic_duty'

module CivicDuty
  Job.last
  .tasks.group_by{|task| task.project.repository.path}
  .reject{|p, tasks| tasks.size == 1}
  .values
  .each(&:shift)
  .flatten(1)
  .each(&:delete)
end
