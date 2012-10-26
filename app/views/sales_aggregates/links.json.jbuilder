json.array!(@sales_aggregates.each) do |agg|
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
