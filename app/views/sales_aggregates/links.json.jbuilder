json.links @sales_aggregates.each do |agg|
    json.tag agg.tag
    json.qty agg.qty
    json.value agg.value
    
    json.made_in agg.made_in.name
    json.sold_in agg.sold_in.name
    
    json.source do
        json.array!([agg.made_in.long, agg.made_in.lat])
    end
    
    json.target do
        json.array!([agg.sold_in.long, agg.sold_in.lat])
    end
end

if not @locales.nil?
    json.locales @locales.each do |loc|
        json.name Locale.find(loc["_id"]).name
        json.lat loc["value"]["lat"]
        json.long loc["value"]["long"]
        json.qty_bought loc["value"]["qty_bought"]
        json.qty_sold loc["value"]["qty_sold"]
        json.value_bought loc["value"]["value_bought"]
        json.value_sold loc["value"]["value_sold"]
    end
end

if not @totals.nil?
    json.totals do
        if not @totals["global"].nil?
            json.global do
                json.qty_bought @totals["global"]["qty_bought"]
                json.qty_sold @totals["global"]["qty_sold"]
                json.value_bought @totals["global"]["value_bought"]
                json.value_sold @totals["global"]["value_sold"]
            end
        end

        if not @locale.nil?
            json.local do
                json.qty_bought @totals["local"]["qty_bought"]
                json.qty_sold @totals["local"]["qty_sold"]
                json.value_bought @totals["local"]["value_bought"]
                json.value_sold @totals["local"]["value_sold"]
            end
        end
    end
end
