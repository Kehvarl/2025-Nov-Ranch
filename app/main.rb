require 'app/ranch.rb'
require 'app/dragon.rb'

def init args
  args.state.ranch = Ranch.new()
  args.state.ranch.new_dragon(Dragon.new({x: 640, y: 360}))
  args.state.ranch.new_dragon(Dragon.new({x: 320, y: 360}))
  args.state.ranch.new_dragon(Dragon.new({x: 960, y: 360}))
end

def tick args
  if Kernel.tick_count <= 0
      init args
  end

  args.state.ranch.tick args

  args.outputs.primitives << args.state.ranch.render
end
