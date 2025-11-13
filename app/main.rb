require 'app/ranch.rb'
require 'app/dragon.rb'

def init args
  args.state.ranch = Ranch.new()
  5.times {args.state.ranch.new_dragon(Dragon.generate())}
end

def tick args
  if Kernel.tick_count <= 0
      init args
  end

  args.state.ranch.tick args

  args.outputs.primitives << args.state.ranch.render
end
