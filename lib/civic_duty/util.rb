module CivicDuty
  module Util
    #INSTANCE = 'travis-ci-garnet-trusty-1512502259-986baf0'
    INSTANCE = 'travisci/ci-garnet:packer-1515445631-7dfb2e1'
    class DockerRunner
      # def run_headless_server
      #   "docker run --name #{build} -dit #{INSTANCE} /sbin/init"
      # end

      # def run_attached_client
      #   "docker exec -it #{build} bash -l"
      # end

      def start
        path = Pathname(__dir__).parent.parent
        "docker run -it -v #{path}:/civic_duty -u travis #{INSTANCE} /bin/bash"
      end

      def build
        @build ||= "build-#{rand}"
      end
    end
  end
end
