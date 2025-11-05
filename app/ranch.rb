class Ranch
    def initialize
        @dragons = []
        @inventory = []
        @weather = nil
        @time_of_day = nil
    end

    def new_dragon dragon
        @dragons << dragon
    end

    def tick args
        @dragons.map {|d| d.tick(args)}
    end

    def render
        @dragons
    end
end
