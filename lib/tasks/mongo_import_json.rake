namespace :mongo_import_json do
    desc "Imports JSON files into the Geocraft MongoDB"

    task :locales, [:filename] => [:environment] do |task, args|
        require 'json'
        
        locales = JSON.parse(File.read(args[:filename]))
        
        locales.each do |loc|
            db_loc = Locale.new(
                :name => loc["name"],
                :type => loc["type"],
                :lat => loc["lat"],
                :long => loc["long"]
            )
            db_loc.save
        end
    end
    
    task :sales_aggregates, [:filename] => [:environment] do |task, args|
        require 'json'
        
        aggs = JSON.parse(File.read(args[:filename]))
            
        aggs.each do |agg|
            db_agg = SalesAggregate.new(
                :tag => agg["tag"],
                :qty => agg["qty"],
                :value => agg["value"],
                :made_in => Locale.where(name: agg["made_in"]).first,
                :sold_in => Locale.where(name: agg["sold_in"]).first
            )
            
            db_agg.save
        end
    end
end
