
class FetchData
    attr_accessor :url
    def fetch_station_data
        uri = URI.parse(self.url)
        response = Net::HTTP.get_response(uri)

        # response = HTTParty.get(self.url)
        response.body
    end

    def json_parser
        JSON.parse(self.fetch_station_data)
    end
end