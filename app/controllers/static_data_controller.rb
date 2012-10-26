class StaticDataController < ApplicationController
    @@json_path = Rails.root.to_s + "/app/assets/data/"
    
    @@world_countries = File.read(@@json_path + "world-countries.geo.json")
    
    @@us_states = File.read(@@json_path + "us-states.geo.json")
    
    @@contiguous_us_states = 
        File.read(@@json_path + "contiguous-us-states.geo.json")
        
    @@us_state_centroids = 
        File.read(@@json_path + "us-state-centroids.geo.json")
        
    @@us_counties = File.read(@@json_path + "us-counties.geo.json")
    
    @@contiguous_us_counties = 
        File.read(@@json_path + "contiguous-us-counties.geo.json")
    
    @@test_arcs = File.read(@@json_path + "test-arcs.geo.json")
    

    def world_countries
        render :json => @@world
    end
    
    def us_states
        render :json => @@us_states
    end
    
    def contiguous_us_states
        render :json => @@contiguous_us_states
    end
    
    def us_state_centroids
        render :json => @@us_state_centroids
    end
    
    def us_counties
        render :json => @@us_counties
    end
    
    def contiguous_us_counties
        render :json => @@contiguous_us_counties
    end
    
    def test_arcs
        render :json => @@test_arcs
    end
end
