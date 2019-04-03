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
      CivicDuty.log "Initiating step '#{step}' for #{task}"
      repository.ready
      build = task.builds.create! step: step, status: :running
      build.update_attributes!(**_run_and_time(step), output: output)
      task.builds.reset
      CivicDuty.log "Finished step '#{step}': #{build.status}"
    end

    private def repository
      project.ready.repository
    end

    private def path
      repository.path
    end

    private def call_system(cmd)
      output << cmd << "\n"
      `#{cmd}`.tap {|r| output << r}
    end

    private def _run_and_time(step)
      starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      {
        **_run(step),
        elapsed_time: Process.clock_gettime(Process::CLOCK_MONOTONIC) - starting,
      }
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

      def runner_class_name
        name.gsub!(/^CivicDuty::/, '')
      end

      # Lookup existing job or create it
      def [](**opts)
        Job.find_or_create_by!(
          runner_class_name: runner_class_name,
          params: opts,
        ) do |job|
          job.tap(&:save!).create_tasks_for(Project.default_set)
        end
      end

      def step(step_name, *args)
        if step_name.is_a?(Hash)
          step_name, alias_name = step_name.first
          alias_method step_name, alias_name
        end
        (@steps ||= []) << step_name
        define_argument_passing(step_name, *args) unless args.empty?
        /^(get|find|produce)_(?<accessor>\w+)$/ =~ step_name
        define_step_accessor(step_name, accessor) if accessor
        step_name
      end

      private def define_argument_passing(step_name, *args)
        args_sig = args.map.with_index{|a, i| "arg_#{i}=#{a}"}.join(', ')
        args_call = args.map.with_index{|a, i| "arg_#{i}"}.join(', ')
        prepend mod = Module.new
        mod.class_eval <<-EVAL, __FILE__, __LINE__ + 1
          def #{step_name}(#{args_sig})
            super(#{args_call})
          end
        EVAL
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
