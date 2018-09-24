module CivicDuty
  class Project < ActiveRecord::Base
    include Grabbable
    belongs_to :repository
    has_many :dependencies
    has_many :project_dependencies, through: :dependencies, source: :depends_on

    has_many :dependents, foreign_key: :depends_on_id, class_name: 'Dependency'
    has_many :dependent_projects, through: :dependents, source: :project

    class << self
      def from_name(name)
        find_or_create_by! name: name
      end
      alias_method :[], :from_name

      def top
        CivicDuty.libraries_io_api.search('', platforms: :rubygems).map do |p|
          from_name(p['name'])
        end
      end

      def grabbed(depth: 0)
        super()
        if depth > 0
          {
            dependencies: project_dependencies,
            dependents: dependent_projects,
          }.each do |kind, projects|
            projects.each do |project|
              project.reload
              yield project, kind: kind, of: self, depth: depth if block_given?
              project.grabbed(depth: depth - 1)
            end
          end
        end
        self
      end
    end

    def libraries_io_data
      api.rubygems.project(name).dependencies.merge(
        dependents: api.rubygems.project(name).dependents
      )
    end

    private def process_raw_data(rank:, repository_url:, dependencies: [], dependents: [], **)
      handle_dependencies(dependencies, self.dependencies, :depends_on)
      handle_dependencies(dependents, self.dependents, :project)

      {
        rank: rank,
        repository: Repository.from_url(repository_url),
      }
    end

    private def handle_dependencies(list, assoc, other_key)
      list
      .map(&:symbolize_keys)
      .select { |dep| dep[:platform] == 'Rubygems' }
      .each do |dep|
        assoc.build(
          other_key => Project.from_name(dep[:name]),
          raw_data: dep,
        )
      end
    end
  end
end
