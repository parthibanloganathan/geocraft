class Locale
  include Mongoid::Document
  
    field :name, type: String
    field :type, type: String # either :city or :county
    
    field :lat, type: Float
    field :long, type: Float
    
    has_many :buys, class_name: "SalesAggregate", inverse_of: :sold_in
    has_many :sells, class_name: "SalesAggregate", inverse_of: :made_in
  
end
