class Egg
    attr_sprite

    def initialize args = {}
        @id        = args.id
        @region_id = args.region_id || 0
        @name      = args.name
        @age       = args.age || 0
        @incubation_required = 10
        @last_update_time = 0

        @x         = args.x || 0
        @y         = args.y || 0
        @w         = 51
        @h         = 54
        @path      = "sprites/circle/white.png"
        @anim_time = 12
        @anchor_x  = 0.5
        @anchor_y  = 0.5
    end

    def tick args
        if args.inputs.mouse.click
            if args.inputs.mouse.inside_rect?(self)
                click(args)
            end
        end
    end

    def click args
    end
end

class Dragon
    attr_sprite

    MOODS = [:leaving, :unhappy, :neutral, :positive, :happy]

    def self.generate args={}
        colors = [:green, :white, :bronze, :aqua]
        moods = [:sleepy, :curious, :playful]
        dragon = Dragon.new({color: colors.sample, mood: moods.sample, x: args.x, y: args.y})
    end

    def initialize args = {}
        @id        = args.id
        @region_id = args.region_id || 0
        @name      = args.name
        @age       = args.age || 0

        @hunger    = args.hunger || 0
        @hunger_rate = 0.01
        @energy    = args.energy || 100
        @energy_rate = -0.01
        @happiness = args.happiness || 0
        @mood      = args.mood || :neutral

        @last_fed_at = args.last_fed_at || 0
        @last_pet_at = args.last_pet_at || 0
        @last_lay_at = args.last_fed_at || 0
        @last_update_time = Time.now.to_i

        @preferred_biomes = args.preferred_biomes || []

        @color     = args.color || :white
        @x         = args.x || 0
        @y         = args.y || 0
        @w         = 51
        @h         = 54
        @path      = "sprites/dragons/#{args.color.to_s}.png" || "sprites/dragons/white.png"
        @frame     = rand(4)
        @frame_cnt = 4
        @anim_time = 12
        @source_x  = 0
        @source_y  = 0
        @source_w  = 16
        @source_h  = 16
        @anchor_x  = 0.5
        @anchor_y  = 0.5
    end

    def energy rate, elapsed
        @energy = (@energy + (rate * elapsed)).clamp(0, 100)
    end

    def hunger rate, elapsed
        @hunger = (@hunger + (rate * elapsed)).clamp(0, 100)
        case @hunger
            when 0
                happiness 5
            when (1...10)
            when (11...25)
            when (26...50)
            when (51...75)
                happiness -1
            when (76...90)
                happiness -2
            when (91...99)
                happiness -3
            when (100...200)
                happiness -5
            end
            if @happiness <= 0
                @mood = :leaving
            end
    end

    def happiness change
        @happiness = (@happiness + change).clamp(0, 100)
    end

    def simulate elapsed, increment=300
        elapsed.div(increment).each do
            hunger @hunger_rate, increment
            energy @energy_rate, increment

        end
        remainder = elapsed % increment
        hunger @hunger_rate, remainder
        energy @energy_rate, remainder
    end

    def update_animation args
        @anim_time -= 1
        if @anim_time <= 0
            @anim_time =  (24 - ((@happiness / 100.0) * 18)).round(0)
            @frame = (@frame + 1) % @frame_cnt
            @source_x = @frame * @source_w
        end
    end

    def tick args
        update_animation(args)
        elapsed = Time.now.to_i - @last_update_time
        simulate(elapsed, 300)
        @last_update_time = Time.now.to_i

        if args.inputs.mouse.click
            if args.inputs.mouse.inside_rect?(self)
                click(args)
            end
        end
    end

    def click args
        happiness 1
        @last_fed_at = Time.now.to_i
    end
end
