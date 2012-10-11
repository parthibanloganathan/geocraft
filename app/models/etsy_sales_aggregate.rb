class EtsySalesAggregate
  include MongoMapper::Document

  key :aggregate, String
  
  key :quantity, Integer
  key :value, Integer
  
  key :city, String
  key :state, String
  key :zip, String
  key :country_id, Integer
  key :country_name, String

end
