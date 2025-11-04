require 'app/dragon.rb'

def init args
  args.state.test = Dragon.new({x: 640, y: 360})
end

def tick args
  if Kernel.tick_count <= 0
      init args
  end
  if args.inputs.mouse.click
    if args.inputs.mouse.inside_rect?(args.state.test)
      args.state.test.click args
    end
  end
  args.outputs.primitives << args.state.test
end
