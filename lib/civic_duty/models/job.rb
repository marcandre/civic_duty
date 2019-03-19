module CivicDuty
  class Job < Model
    include Formatting

    has_many :tasks
    serialize :params

    delegate :step_after, :stages, to: :runner_class

    def runner_class
      "CivicDuty::#{runner_class_name}".constantize
    end

    def runner_class=(klass)
      self.runner_class_name = klass.runner_class_name
    end

    def create_tasks_for(projects)
      ids = projects.respond_to?(:pluck) ? projects.pluck(:id) : Array(projects).map(&:id)
      ids.each do |id|
        tasks.create!(project_id: id)
      end
      self
    end

    def run
      tasks.each(&:run)
      self
    end

    def report
      @report = +''
      tasks.group_by(&:status).then do |success: [], **by_status|
        report_by_status(by_status) unless by_status.empty?
        report_success(success)
      end
      @report
    end

    private def report_by_status(by_status)
      section 'Not completed:', by_status.map { |status, tasks|
        "#{status}: #{summarize_list(project_names(tasks))}"
      }
    end

    private def report_success(tasks)
      return section 'Completed:', ['None'] if tasks.empty?

      by_synthesis = tasks
        .group_by(&:synthesis)
        .sort
      by_synthesis = regroup(by_synthesis) if by_synthesis.size > 7

      section 'Completed:',
        by_synthesis.reverse.map { |(index, tasks)|
          "#{index}: #{summarize_list(project_names(tasks))}"
        }

      tasks, extra = shorten_list(by_synthesis.flat_map(&:last).flatten)

      section 'Summaries:', [*tasks.map(&:summary), *extra]
    end

    private def section(title, values)
      @report << "*** #{title} ***\n"  << values.join("\n") << "\n\n"
    end

    private def project_names(tasks)
      tasks.map(&:project).map(&:name)
    end
  end
end
