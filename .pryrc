require './lib/civic_duty'

Pry.config.hooks.add_hook(:when_started, :set_context) { |binding, options, pry|
  if binding.eval('self').class == Object # true when starting `pry`
                                          # false when called from binding.pry
    pry.input = StringIO.new("cd CivicDuty")
  end
}
