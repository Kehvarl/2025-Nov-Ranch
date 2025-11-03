require 'app/dragon.rb'

def init args
  args.state.test = Dragon.new()
end

def tick args
  if Kernel.tick_count <= 0
      init args
  end
  args.outputs.primitives << args.state.test.render(640,320)
end
