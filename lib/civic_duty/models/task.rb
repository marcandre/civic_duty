module CivicDuty
  class Task < Model
    belongs_to :job
    belongs_to :project
    has_many :builds,
      -> { order(:created_at) },
      inverse_of: :task,
      dependent: :destroy

    serialize :synthesis
    enum status: %i[pending running intermediate_step success failure error]
    symbol_column :stage

    def last_build(step = nil)
      assoc = builds
      assoc = builds.where(step: step) if step
      assoc.last
    end

    def finished?
      %i[success failure error].include?(status)
    end

    def can_run?
      !finished? && project.repository.ready?
    end

    def step_result(step = nil)
      last_build(step)&.result
    end

    def run
      while can_run?
        step = job.step_after(stage)
        run_step(step)
      end
      self
    end

    def to_s
      "#<#{self.class} id: #{id}, project: '#{project&.name}'>"
    end

    private def run_step(step)
      job_runner.run(step)
    end

    private def job_runner
      job.runner_class.new(self)
    end

    CACHE = %i[stage status summary synthesis total_elapsed_time]

    private def _stage
      builds.success.last&.step || Job::Runner::INITIAL_STAGE
    end

    private def _status
      s = last_build&.status || :pending
      s = :intermediate_step if s == :success && _stage != job.stages.last
      s
    end

    private def _synthesis
      return status unless _status == :success
      job_runner.synthesis || _status
    end

    private def _summary
      return nil unless _status == :success
      job_runner.summary
    end

    private def _total_elapsed_time
      builds.sum(:elapsed_time)
    end

    def cache_builds!
      update_attributes(
        h = CACHE.to_h do |column|
          [column, send(:"_#{column}")]
        end
      )
    end
  end
end
