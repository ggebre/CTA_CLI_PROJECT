class StationController 
    # accept a route and checks if the route is valid
    #valid route should return all the name of the stops 
    # include StationModule::InstanceMethods 
    attr_accessor :route, :json_data, :depart_from, :station_id
    

    # NEW ADDITION
    def station_name_valid?
        Station.all.detect {|station| station.name.downcase == @depart_from.downcase}
    end
    
    
    # ALL ROUTES 
    def print
        routes_stop_names.each {|name| puts name}
    end

    def routes_stop_names
        Station.cta_routes.map {|station| self.route_formatter(station.route)} 
    end

    # END ALL ROUTES

    # all stations routes for a given route 
    def route_name_valid?
        Station.cta_routes.detect {|station| station.route.downcase == @route.downcase}
    end

    def routes_stops_for_a_route
        self.input_formatter
        if route_name_valid?
            Station.stations_for_a_route(@route)
        end
    end

    def print_route_stops
        routes_stops_for_a_route.each {|station| puts station.name} 
    end
    # END
    def self.reset 
        Station.reset
    end

    
    # ARRIVAL TIMES FOR A GIVEN STATION_ID AND ROUTE 
    def departure_station_id
        # returns the station_id for a valid station name
        if self.station_name_valid?
            @station_id = Station.station_id_with(@depart_from)
        end
    end
    def arrival_times
        self.departure_station_id
        Station.trains_arriving_at_station(@station_id).map do |station|
            station.route = self.route_formatter(station.route)
            station.arrival_time = self.time_formatter (station.arrival_time)
            station 
        end       
    end
    def print_arrival_times
        
        self.arrival_times.each do |station|
            puts "========================="
                    # puts station.name
            puts "#{station.route}              #{station.destination}"
            puts "#{station.arrival_time}"
            puts "========================="
        end
    end
    
    # END
    def fetch_data_from_json
        Station.create_station_from_json(@json_data)
    end


    def route_formatter (route)
       
        formatted_route = route 
        case formatted_route
        when "G"
            formatted_route = "Green"
        when "P"
            formatted_route = "Purple"
        when "Y"
            formatted_route = "Yellow"
        when "Org"
            formatted_route = "Orange"
        when "Brn" 
            formatted_route = "Brown"
        end
        formatted_route
    end

    # 
    def input_formatter
        route = @route
        case route 
        when "green"
            route = "G"
        when "purple"
            route = "P"
        when "yellow"
            route = "Y"
        when "orange"
            route = "Org"
        when "brown" 
            route = "Brn"
        end
        @route = route.capitalize 
    end
    def time_formatter (arrival_time)
        string = arrival_time.match(/T.+/).to_s[1..-1]
        time = Time.parse(string)
        time.strftime("%I:%M %p")
    end
    
end