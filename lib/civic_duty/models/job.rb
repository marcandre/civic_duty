module CivicDuty
  class Job < Model
    include Formatting

    has_many :tasks, dependent: :destroy
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

    def temp(source)
      Project.temp(source) do |project|
        yield task = tasks.create!(project: project)
      ensure
        task&.destroy
      end
    end

    def test(source)
      temp(source, &:run)
    end

    private def report_by_status(by_status)
      section 'Not completed:', by_status.map { |status, tasks|
        "#{status}: #{summarize_list(project_names(tasks))}"
      }
    end

    private def report_success(tasks)
      return section 'Completed:', ['None'] if tasks.empty?

      results = tasks.to_h { |task| [task, task.synthesis] }

      if Summarizer.new(results.first.last).result_type == :tally
        merged = {}.merge!(*results.values) { |k, nb1, nb2| nb1 + nb2 }
        section 'Combined:', [Summarizer.new(merged, group: {bottom: 8, merge: 1}).summary]
        results.transform_values! { |tally| tally.values.sum }
      end

      s = Summarizer.new(
        results,
        object_to_s: -> (task) { task.project.name }
      )

      section 'Completed:', [s.summary]

      tasks, extra = shorten_list(s.sorted_tally_values, ok: 10)
      summaries = tasks.flat_map { |task| ["* #{task.project.name} *", task.summary] }

      section 'Summaries:', [*summaries, *extra]
    end

    private def section(title, values)
      @report << "*** #{title} ***\n"  << values.join("\n") << "\n\n"
    end

    private def project_names(tasks)
      tasks.map(&:project).map(&:name)
    end
  end
end
