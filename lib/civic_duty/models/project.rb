module CivicDuty
  class Project < Model
    include Grabbable
    belongs_to :repository
    has_many :dependencies
    has_many :project_dependencies, through: :dependencies, source: :depends_on

    has_many :dependents, foreign_key: :depends_on_id, class_name: 'Dependency'
    has_many :dependent_projects, through: :dependents, source: :project

    def to_s
      "#<CivicDuty::Project '#{name}'>"
    end

    class << self
      def from_name(name)
        find_or_create_by! name: name
      end
      alias_method :[], :from_name

      def top(n = 100)
        pages = n.div(100) + 1
        (1..pages).flat_map do |page|
          CivicDuty.libraries_io_api.search(
            '',
            platforms: :rubygems,
            page: page,
            per_page: [n, 100].min,
          ).map do |p|
            from_name(p['name'])
          end
        end.first(n)
      end
    end

    def grabbed(depth: 0, dependencies: true, dependents: true, sources: false)
      super()
      if depth > 0
        {
          dependencies: dependencies ? project_dependencies : [],
          dependents: dependents ? dependent_projects : [],
        }.each do |kind, projects|
          projects.each do |project|
            project.reload
            yield project, kind: kind, of: self, depth: depth if block_given?
            project.grabbed(depth: depth - 1, dependencies: dependencies, dependents: dependents, sources: sources)
          end
        end
      end
      repository&.fetch if sources
      self
    end

    def libraries_io_data
      api.rubygems.project(name).dependencies.merge(
        dependents: api.rubygems.project(name).dependents
      )
    end

    private def process_raw_data(repository_url:, dependencies: [], dependents: [], **)
      handle_dependencies(dependencies, self.dependencies, :depends_on)
      handle_dependencies(dependents, self.dependents, :project)

      {
        repository: Repository.from_url(repository_url),
        **super
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
