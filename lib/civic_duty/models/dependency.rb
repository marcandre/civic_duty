module CivicDuty
  class Dependency < Model
    belongs_to :project
    belongs_to :depends_on, class_name: 'Project'
  end
end
