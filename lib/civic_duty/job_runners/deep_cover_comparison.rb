module CivicDuty
  class DeepCoverComparison < Job::Runner
    # tools

    def get_coverage
      run_test_suite
      parse_coverage
    end

    def parse_coverage
      output.match(/Coverage report generated .* (?<covered>\d+) \/ (?<total>\d+) LOC \(\d+.*%\) covered/)
        &.named_captures or fail 'SimpleCov report not found'
    end

    # steps

    step def simple_cov_require
      find_require 'simple_cov'
    end

    step get_builtin_coverage: :get_coverage

    step def patch_for_deep_cover
      simple_cov_require.patch(before: "require 'deep-cover/takeover'")
      nil
    end

    step get_deep_cover_coverage: :get_coverage

    step def produce_report
      {
        'Builtin': builtin_coverage,
        'DeepCover': deep_cover_coverage,
      }.map do |tool, cov|
        "#{tool} coverage: #{cov[:covered]} / #{cov[:total]}"
      end.join("\n")
    end

    def run_test_suite
      call_system 'rake test'
    end

    def find_require path

    end
  end
end
