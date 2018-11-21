module CivicDuty
  module StepHelpers
    def count_occurrences(pat)
      call_system("grep #{pat} #{path} -R --include='*.rb' | wc -l").to_i
    end
  end
end
