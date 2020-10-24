module StationModule
    module InstanceMethods 
        def initialize 
            self.class.all << self
        end

    end
    module ClassMethods
        
    end

end