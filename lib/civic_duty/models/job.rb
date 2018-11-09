module CivicDuty
  class Job < Model
    has_many :tasks
    serialize :params

    delegate :step_after, :stages, to: :runner_class

    def runner_class
      "CivicDuty::#{runner_class_name}".constantize
    end

    def runner_class=(klass)
      self.runner_class_name = runner_class.name
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
  end
end
