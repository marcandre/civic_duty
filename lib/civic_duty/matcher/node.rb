module CivicDuty
  class Matcher::Node
    def initialize(type: nil, nb_args: nil, **args)
      @type = type
      @nb_args = nb_args
      @args = args
    end

    def ===(node)
      (@type.nil? || @type === node.type) &&
        (@nb_args.nil? || @nb_args === node.children.size) &&
        @args.all? do |key, matcher|
          index = Integer(key[/\d+$/]) rescue raise("Invalid key: #{key}. Must end with child index")
          value = node.children.fetch(index) { return false }
          matcher === value
        end
    end

    def to_proc
      method(:===).to_proc
    end
  end
end
