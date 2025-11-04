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
        @energy    = args.energy || 100
        @happiness = args.happiness || 50
        @bond      = args.bond || 0
        @last_interaction = args.last_interaction || 0
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

    def click args
        @w += 5
        @h += 5
    end
end
