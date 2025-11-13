class Ranch
    BIOMES = [:meadow, :forest, :volcanic, :cavern, :aquatic]
    BIOME_COLORS = {
        meadow:{r:0,g:64,b:64},
        forest:{r:0,g:192,b:64},
        volcanic:{r:192,g:32,b:32},
        cavern:{r:64,g:64,b:64},
        aquatic:{r:0,g:64,b:192},
    }

    def adjacent_biomes(biome)
    i = BIOMES.index(biome)
    [
        BIOMES[(i - 1) % BIOMES.length],
        BIOMES[i],
        BIOMES[(i + 1) % BIOMES.length]
    ]
    end

    def initialize
        @dragons = []
        @inventory = []
        @regions = [{x:0, y:0, w:1280, h:720, biome: :meadow}]
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
                    regions << r
                    next
                end
                regions << {x:r.x, y:r.y, w:(nx-r.x), h:r.h, biome:adjacent_biomes(r.biome).sample()}
                regions << {x:nx, y:r.y, w:(r.w-(nx-r.x)), h:r.h, biome:adjacent_biomes(r.biome).sample()}
            elsif mode == 1
                ny = Numeric.rand((r.y+16)..(r.y+r.h-16))
                if (ny - r.y) < min_size or (r.h - (ny-r.y)) < min_size
                    regions << r
                    next
                end
                regions << {x:r.x, y:r.y, w:r.w, h:(ny-r.y), biome:adjacent_biomes(r.biome).sample()}
                regions << {x:r.x, y:ny, w:r.w, h:(r.h-(ny-r.y)), biome:adjacent_biomes(r.biome).sample()}
            else
                regions << r
            end
        end
        @regions = regions
    end

    def placement_grid
        for r in @regions
            r.grid = []
            (r.x + 32).step(r.x + r.w - 32, 64).each do |x|
                (r.y + 32).step(r.y + r.h - 32, 64).each do |y|
                    r.grid << [x + Numeric.rand(-8..8), y + Numeric.rand(-8..8)]
                end
            end
        end
    end

    def new_dragon dragon
        available_regions = @regions.select { |r| r[:grid].any? }
        if not available_regions.empty?

            region = available_regions.sample
            while region.grid.size <= 0
                region = @regions.sample
            end
            pos = region.grid.sample()
            region.grid.delete(pos)
            dragon.x = pos[0]
            dragon.y = pos[1]
            @dragons << dragon
        end
    end

    def tick args
        @dragons.map {|d| d.tick(args)}
    end

    def render
        out = []
        for r in @regions
            out << {x:r.x, y:r.y, w:r.w, h:r.h, r:128, g:0, b:0}.border!
            out << {x:r.x, y:r.y, w:r.w, h:r.h, **BIOME_COLORS[r.biome], a:32}.solid!
        end
        out << @dragons
        out
    end
end
