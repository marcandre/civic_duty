module CivicDuty
  class Task < Model
    belongs_to :job
    belongs_to :project
    has_many :builds, -> { order(created_at: :desc) }

    def stage
      builds.success.last&.step || Job::Runner::INITIAL_STAGE
    end

    def last_build(step = nil)
      assoc = builds
      assoc = build.where(step: step) if step
      assoc.last
    end

    def status
      last_build&.status
    end

    def finished?
      %i[success failure error].include?(status)
    end

    def can_run?
      !finished? && project.repository.ready?
    end

    def step_result(step = nil)
      last_build(step).result
    end

    def run
      while can_run?
        run_next_step
      end
      self
    end

    def run_next_step
      run_step(job.step_after(stage))
      self
    end

    private def run_step(step)
      job.runner_class.new(self).run(step)
    end
  end
end
