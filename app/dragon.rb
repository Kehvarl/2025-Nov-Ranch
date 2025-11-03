class Dragon
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
        @color     = args.color || :white
        @sprite    = args.sprite || :white
        @bond      = args.bond || 0
        @last_interaction = args.last_interaction || 0
        @status    = args.status || :idle
    end

    def render x,y
        {x: x, y: y, w: 51, h: 54,
         path: 'sprites/dragons/dragon_sprite_1x.png',
         source_x: 0, source_y: 36,
         source_w: 17, source_h: 18,
        }.sprite!
    end
end
