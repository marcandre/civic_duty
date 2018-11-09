module CivicDuty
  class Job::Runner
    include StepHelpers

    attr_reader :output, :task
    delegate :job, :project, to: :task
    delegate :params, to: :job

    def initialize(task)
      @task = task
      @output = ""
    end

    def run(step)
      CivicDuty.log "Initiating step '#{step}'"
      repository.checkout!
      build = task.builds.create! step: step, status: :running
      build.update_attributes!(**_run(step), output: output)
      CivicDuty.log "Finished step '#{step}': #{build.status}"
    end

    private def repository
      project.grabbed.repository
    end

    private def path
      repository.path
    end

    private def call_system(cmd)
      output << cmd << "\n"
      `#{cmd}`.tap {|r| output << r}
    end

    private def _run(step)
      {
        status: :success,
        result: send(step),
      }
    rescue RuntimeError => e
      output << e.to_s
      { status: :failure }
    rescue Exception => e
      output << e.to_s << e.backtrace.join("\n")
      { status: :error }
    end

    INITIAL_STAGE = :_started_

    class << self
      attr_reader :steps, :stages

      def step(step_name = nil, **mapping)
        raise ArgumentError, "Pass `step_name` or `step_name: :method`" if mapping.size != (step_name ? 0 : 1)
        unless step_name
          step_name, alias_name = mapping.first
          alias_method step_name, alias_name
        end
        (@steps ||= []) << step_name
        /^(get|find|produce)_(?<accessor>\w+)$/ =~ step_name
        define_step_accessor(step_name, accessor) if accessor
        step_name
      end

      private def define_step_accessor(step_name, accessor)
        class_eval <<-EVAL, __FILE__, __LINE__ + 1
          def #{accessor}
            task.step_result(:#{step_name})
          end
        EVAL
      end

      def param(param_name, default: nil)
        class_eval <<-EVAL, __FILE__, __LINE__ + 1
          def #{param_name}
            params.fetch(:#{param_name}, #{default.inspect})
          end
        EVAL
      end

      def stages
        [INITIAL_STAGE, *steps]
      end

      # Note: `step_after(last_stage)` returns `nil`
      def step_after(stage)
        index = stages.find_index(stage) or raise "Unknown stage #{stage}"
        stages[index + 1]
      end
    end
  end
end
