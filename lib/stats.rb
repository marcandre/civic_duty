p =  Repository.where(scm: 'git').select(&:ready?).map{|r| r.projects.first}
j = Job.create!(runner_class: CountRelativeAutoload)
                .create_tasks_for(p)
                .run



r = Repository.where(scm: 'git').select(&:ready?); r.count
r.each(&:branch)



a = [
{all: 3, relative: 2},
{all: 5, relative: 1},
]


using = a.select{|h| h[:all] > 0}; using.count
rel = using.map{|h| (h[:relative] * 100 / h[:all]).round(2)}; withrel = rel.reject(&:zero?); withrel.count
ave = withrel.sum / withrel.count

a.inject{|x, y| x.merge(y){|h, v1, v2| v1 + v2}}







Job.last.tasks.select{|t| t.last_build&.result}.sort_by{|t| t.step_result[:all]}.last(5)
