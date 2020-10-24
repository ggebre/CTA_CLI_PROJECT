
require 'pry'
require 'dotenv'
require "httparty"
require 'net/http'
require 'open-uri'
require 'json'
require 'time'
require 'colorize'
Dotenv.load


require_relative './fetch.rb'
require_relative './concerns/station_module'
require_relative 'stations.rb'
require_relative 'station_controller.rb'


class Cli
    
    attr_accessor :json_data, :route, :depart_from, :station_id
    def run 
        
        puts "Welcome to cta train schedule gem: "
        puts "Loading...."
        @json_data = self.parse_data 
        # 1. fetch all the necessary data from the API 
        # self.fetch_data_from_json
        station_controller = StationController.new
        station_controller.json_data = self.parse_data
        station_controller.fetch_data_from_json
        # # 2. display the different routes 
        station_controller.print
        
        run_route_selection(station_controller)
        

    end
    def run_route_selection(station_controller)
        # 3. Prompt user to select the route
        # print the routes stations if the selection is valid
        puts "Enter the route color or type exit: ".colorize(:blue)
        route = gets.chomp.downcase
        station_controller.route = route
        if route != 'exit'
            if station_controller.routes_stops_for_a_route
                puts "=======  LIST OF STOPS FOR #{route} =========="
                station_controller.print_route_stops
            else
                run_route_selection(station_controller)
            end
            run_departure_selection(station_controller)
        else
            return
        end
    end
    def run_departure_selection(station_controller)
        # 4 prompts for the station from which the user departs from
        # prints out the arrival times for the particular station 
        puts "Enter your departure station or exit".colorize(:blue)
        @depart_from = gets.chomp
        station_controller.depart_from = @depart_from
        # binding.pry
        if @depart_from.downcase != 'exit'
            if station_controller.departure_station_id
                station_controller.print_arrival_times
            else
                run_departure_selection(station_controller)
            end
            run
        else
            return
        end
    end

    def parse_data
        # train routes -> red, blue, green, yellow...
        self.json_data["ctatt"]["eta"]
    end
    def json_data
        fetch = FetchData.new
        fetch.url = "http://lapi.transitchicago.com/api/1.0/ttarrivals.aspx?key=#{ENV['API_KEY']}&mapid=&outputType=JSON"
        # fetchs all the stations and train arrival times 
        fetch.json_parser
    end
   
   
end

Cli.new.run



