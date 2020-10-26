
# should have all the stations in chicago with their detail
class Station
    include StationModule::InstanceMethods 
    @@all = []
    attr_accessor :id, :name, :route_number, :destination, :route, :arrival_time, :long, :lat
    
    # def initialize 
    #     @@all << self
    # end

    def self.all
        @@all
    end

    def self.create_station_from_json(json_array)
        json_array.map do |station|
            new_station = self.new
            new_station.id = station["staId"]
            new_station.name = station["staNm"]
            new_station.route_number = station["rn"]
            new_station.destination = station["stpDe"]
            new_station.route = station["rt"]
            new_station.arrival_time = station["arrT"]
            new_station.long = station["lon"]
            new_station.lat = station["lat"]
            new_station
        end
    end
    # NEW ADDITION
    # returns the id of a given station
    def self.station_id_with(name)
        station_id = self.all.detect {|station| station.name.downcase == name.downcase}.id 
    end
    
    def self.cta_routes
        # find all the routes of the train
        self.all.uniq {|station| station.route}
    end
    
    def self.stations_for_a_route (route) 
        self.all.select {|station| station.route == route}.uniq{|station| station.name}
    end

    def self.reset
        @@all.clear
    end

    def self.trains_arriving_at_station (id)
        # given station_id -> arrival times 
        stations = self.all.select {|station| station.id == id}
        
    end
    def self.reset
        self.all.clear
    end
    
end


