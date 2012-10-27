class StaticDataController < ApplicationController
    @@json_path = Rails.root.to_s + "/app/assets/data/"
    
    def world_countries
        countries = File.read(@@json_path + "world-countries.geo.json")
        render :json => countries
    end
    
    def us_states
        states = File.read(@@json_path + "us-states.geo.json")
        render :json => states
    end
    
    def contiguous_us_states
        states = File.read(@@json_path + "contiguous-us-states.geo.json")
        render :json => states
    end
    
    def us_state_centroids
        centroids = File.read(@@json_path + "us-state-centroids.geo.json")
        render :json => centroids
    end
    
    def us_counties
        counties = File.read(@@json_path + "us-conties.geo.json")
        render :json => counties
    end
    
    def contiguous_us_counties
        counties = File.read(@@json_path + "contiguous-us-counties.geo.json")
        render :json => counties
    end
end
