Geocraft::Application.routes.draw do

  resources :locales
  
  resources :sales_aggregates do
    collection { get 'links' }
  end

  # Hack to serve static json, see static_json_controller.rb
  match "/data/world-countries" => "static_data#world_countries"
  match "/data/us-states" => "static_data#us_states"
  match "/data/contiguous-us-states" => "static_data#contiguous_us_states"
  match "/data/us-state-centroids" => "static_data#us_state_centroids"
  match "/data/us-counties" => "static_data#us_counties"
  match "/data/contiguous-us-counties" => "static_data#contiguous_us_counties"
  match "/data/test-arcs" => "static_data#test_arcs"

  root :to => "home#index"

end
