class Ranch
    def initialize
        @dragons = []
        @inventory = []
        @regions = [{x:0, y:0, w:1280, h:720}]
        @weather = nil
        @time_of_day = nil
        while @regions.size < 3
            bsp()
        end
        placement_grid()
    end

    def setup
    end

    def bsp min_size=128
        regions = []
        for r in @regions
            mode = rand(4)
            if mode == 0
                nx = Numeric.rand((r.x+16)..(r.x+r.w-16))
                if (nx - r.x) < min_size or (r.w - (nx-r.x)) < min_size
                    regions << {x:r.x, y:r.y, w:r.w, h:r.h}
                    next
                end
                regions << {x:r.x, y:r.y, w:(nx-r.x), h:r.h}
                regions << {x:nx, y:r.y, w:(r.w-(nx-r.x)), h:r.h}
            elsif mode == 1
                ny = Numeric.rand((r.y+16)..(r.y+r.h-16))
                if (ny - r.y) < min_size or (r.h - (ny-r.y)) < min_size
                    regions << {x:r.x, y:r.y, w:r.w, h:r.h}
                    next
                end
                regions << {x:r.x, y:r.y, w:r.w, h:(ny-r.y)}
                regions << {x:r.x, y:ny, w:r.w, h:(r.h-(ny-r.y))}
            else
                regions << {x:r.x, y:r.y, w:r.w, h:r.h}
            end
        end
        @regions = regions
    end

    def placement_grid
        for r in @regions
            r.grid = []
            (r.x + 16).step(r.x + r.w - 32, 64).each do |x|
                (r.y + 16).step(r.y + r.h - 32, 64).each do |y|
                    r.grid << [x + Numeric.rand(-8..8), y + Numeric.rand(-8..8)]
                end
            end
        end
    end

    def new_dragon dragon
        region = @regions.sample
        while region.grid.size <= 0
            region = @regions.sample
        end
        pos = region.grid.sample()
        region.grid.delete(pos)
        dragon.x = pos[0]
        dragon.y = pos[1]
        @dragons << dragon
    end

    def tick args
        @dragons.map {|d| d.tick(args)}
    end

    def render
        out = []
        for r in @regions
            out << {x:r.x, y:r.y, w:r.w, h:r.h, r:128, g:0, b:0}.border!
        end
        out << @dragons
        out
    end
end
