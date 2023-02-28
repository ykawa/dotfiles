# vim: set fenc=utf-8 ff=unix ft=ruby ts=4 sw=4 sts=4 si et :

IRB_START_TIME = Time.now

require 'yaml'
require 'pp'
require 'rubygems'
require 'irb/completion'
require 'irb/ext/save-history'

require 'map_by_method'
require 'what_methods'
require 'duration'
require 'wirble'

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"
IRB.conf[:PROMPT_MODE] = :SHORT
IRB.conf[:PROMPT][:SHORT] = {
  :PROMPT_C=>"%03n:%i* ",
  :RETURN=>"%s\n",
  :PROMPT_I=>"%03n:%i> ",
  :PROMPT_N=>"%03n:%i> ",
  :PROMPT_S=>"%03n:%i%l "
}
IRB.conf[:SAVE_HISTORY] = 10000
IRB.conf[:USE_READLINE] = true

# Turn turn on colorization, off other wirble wierdness
Wirble.init(:skip_prompt => true, :skip_history => true)
Wirble.colorize

def quick(repetitions=100, &block)
  require 'benchmark'
  Benchmark.bmbm do |b|
    b.report {repetitions.times &block}
  end
  nil
end

class Object
  def interesting_methods
    (self.methods - Object.new.methods).sort
  end
end

at_exit { puts Duration.new(Time.now - IRB_START_TIME) }

