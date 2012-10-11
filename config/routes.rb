Geocraft::Application.routes.draw do
  get "home/index"

  resources :etsy_sales_aggregates

  root :to => "home#index"
end
