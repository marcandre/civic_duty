require 'thor'
require_relative '../civic_duty'

module CivicDuty
  module Patch
    def run(instance, args = [])
      args << instance.options.to_h.transform_keys(&:to_sym)
      super
    end
  end

  ::Thor::Command.prepend Patch

  class Runner < Thor
    desc 'grab PROJECT', 'Grab a project'
    option :reverse,      type: :boolean, aliases: '-r', default: false, desc: '...and its reverse dependencies'
    option :dependencies, type: :boolean, aliases: '-d', default: false, desc: '...and its dependencies'
    option :sources,      type: :boolean, aliases: '-s', default: false, desc: '...and the sources'
    def grab(name, reverse:, dependencies:, sources:)
      Project.from_name(name).grabbed(
        depth: 1,
        dependencies: dependencies,
        dependents: reverse,
        sources: sources,
      )
    end
  end
end
