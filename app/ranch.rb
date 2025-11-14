class Ranch
    BIOMES = [:meadow, :highland, :volcanic, :cavern, :aquatic]
    BIOME_COLORS = {
        meadow:   {r:120, g:220, b:120}, # bright spring greens
        highland: {r:180, g:160, b:100},  # earthy tan with grass undertones
        volcanic: {r:255, g:90,  b:60},  # glowing lava orange-red
        cavern:   {r:100, g:100, b:120}, # cool stone gray-blue
        aquatic:  {r:80,  g:160, b:255}, # clear blue water
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
        @eggs = []
        @inventory = []
        @regions = [{x:0, y:0, w:1280, h:720, biome: :meadow, eggs:[], dragons:[]}]
        @weather = nil
        @time_of_day = nil
        while @regions.size < 8
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
                regions << {x:r.x, y:r.y, w:(nx-r.x), h:r.h,
                            biome:adjacent_biomes(r.biome).sample(), eggs:[], dragons:[]}
                regions << {x:nx, y:r.y, w:(r.w-(nx-r.x)), h:r.h,
                            biome:adjacent_biomes(r.biome).sample(), eggs:[], dragons:[]}
            elsif mode == 1
                ny = Numeric.rand((r.y+16)..(r.y+r.h-16))
                if (ny - r.y) < min_size or (r.h - (ny-r.y)) < min_size
                    regions << r
                    next
                end
                regions << {x:r.x, y:r.y, w:r.w, h:(ny-r.y),
                            biome:adjacent_biomes(r.biome).sample(), eggs:[], dragons:[]}
                regions << {x:r.x, y:ny, w:r.w, h:(r.h-(ny-r.y)),
                            biome:adjacent_biomes(r.biome).sample(), eggs:[], dragons:[]}
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
        add_dragon(dragon, get_allowed_region())
    end

    def get_allowed_region biomes=[:meadow, :highland, :volcanic, :cavern, :aquatic]
        available_regions = @regions.select { |r| r[:grid].any? and biomes.include?(r[:biome]) }
        if not available_regions.empty?
            region_id = @regions.find_index(available_regions.sample)
        end
    end

    # dragon management
    def add_dragon(dragon, region_id)
        region = @regions[region_id]
        pos = region.grid.sample()
        region.grid.delete(pos)
        dragon.x = pos[0]
        dragon.y = pos[1]
        @dragons << dragon
    end

    def remove_dragon(dragon_id); end
    def move_dragon(dragon_id, new_region_id); end

    # egg management
    def add_egg(egg, region_id); end
    def remove_egg(egg_id); end
    def move_egg(egg_id, new_region_id); end

    # lookup helpers
    def dragons_in_region(region_id); end
    def eggs_in_region(region_id); end
    def region_for_dragon(dragon_id); end
    def region_for_egg(egg_id); end

    def tick args
        @dragons.map {|d| d.tick(args)}
    end

    def render
        out = []
        for r in @regions
            out << {x:r.x, y:r.y, w:r.w, h:r.h, r:128, g:0, b:0}.border!
            out << {x:r.x, y:r.y, w:r.w, h:r.h, **BIOME_COLORS[r.biome], a:64}.solid!
        end
        out << @dragons
        out
    end
end
