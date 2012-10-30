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
        json.buys loc["value"]["buys"]
        json.sells loc["value"]["sells"]
    end
end

if not @totals.nil?
    json.totals do
        json.purchases @totals["purchases"]
        json.sales @totals["sales"]
        if not @totals["local_purchases"].nil?
            json.local_purchases @totals["local_purchases"]
        end
        if not @totals["local_sales"].nil?
            json.local_sales @totals["local_sales"]
        end
    end
end
