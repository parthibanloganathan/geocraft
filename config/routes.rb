Geocraft::Application.routes.draw do
  get "home/index"

  # Hack to serve static json, see static_json_controller.rb
  match "/data/world-countries" => "static_data#world_countries"
  match "/data/us-states" => "static_data#us_states"
  match "/data/contiguous-us-states" => "static_data#contiguous_us_states"
  match "/data/us-state-centroids" => "static_data#us_state_centroids"
  match "/data/us-counties" => "static_data#us_counties"
  match "/data/test-arcs" => "static_data#test_arcs"

  resources :etsy_sales_aggregates

  root :to => "home#index"
end
