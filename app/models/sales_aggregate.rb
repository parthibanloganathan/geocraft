class SalesAggregate 
  include Mongoid::Document
  
    field :tag, type: String
    
    field :qty, type: Integer
    field :value, type: BigDecimal
    
    belongs_to :made_in, class_name: "Locale", inverse_of: :sells
    belongs_to :sold_in, class_name: "Locale", inverse_of: :buys

end
