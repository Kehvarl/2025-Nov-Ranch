class Dragon
    attr_sprite
    def initialize args = {}
        @id        = args.id
        @name      = args.name
        @age       = args.age || 0
        @stage     = args.stage || 0
        @growth    = args.growth || 0
        @traits    = args.traits || []
        @mood      = args.mood || ""
        @hunger    = args.hunger || 0
        @hunger_rate = 0.01
        @energy    = args.energy || 100
        @energy_rate = -0.01
        @happiness = args.happiness || 50
        @bond      = args.bond || 0
        @last_interaction = args.last_interaction || 0
        @last_update_time = Time.now.to_i
        @status    = args.status || :idle
        @color     = args.color || :white
        @x         = args.x || 0
        @y         = args.y || 0
        @w         = 51
        @h         = 54
        @path      = 'sprites/dragons/dragon_sprite_1x.png'
        @source_x  = 18
        @source_y  = 36
        @source_w  = 17
        @source_h  = 18
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

    def tick args
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
        @bond = (@bond + 0.1).clamp(0,100)
        if @bond > 10
            happiness 1
        end
        @h += 5
        @w += 5
    end
end
