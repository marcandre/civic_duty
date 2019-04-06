require_relative '../../civic_duty'

module CivicDuty
  job = NodeStats['(block _ (args arg arg) _)', store_names: true]
  tasks = job.tasks.success

  results = tasks.to_h { |task| [task, task.synthesis] }
  merged = {}.merge!(*results.values) { |k, nb1, nb2| nb1 + nb2 }

  words = merged.keys.map { |first, second| second if first == :_ }.compact
  i_words = merged.keys.map { |first, second| first == :i ? second : second == :i ? first : nil }.compact

  {
    %i[key value] => %i[k v _k v _v k key val k val key values],
    %i[hash key] => %i[h k _ key],
    %i[x y] => (:a...:x).flat_map { |s| [s, s.succ]}.concat(%i[y z]),
    %i[x i] => (:a..:z).flat_map { |s| [s, :i].sort},
    %i[x _] => (:a...:x).flat_map { |s| [:_, s].sort}.concat(%i[_ y _ z]),
    %i[some_word _] => words.flat_map { |s| [:_, s].sort},
    %i[some_word i] => i_words.flat_map { |s| [s, :i].sort},
  }.each do |canonical, alternatives|
    merged[canonical] ||= 0
    alternatives.each_slice(2) { |alt| merged[canonical] += merged.delete(alt) || 0 }
  end

  puts Summarizer.new(merged, group: {bottom: 8, merge: 1, top: 0}).summary
end
