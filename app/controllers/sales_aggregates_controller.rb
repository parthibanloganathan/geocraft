class SalesAggregatesController < ApplicationController
    # GET /sales_aggregates/tags.json
    # Alias: GET /tags.json
    def tags
        map = %Q{ function() { 
            emit(this.tag, { qty: this.qty, value: this.value });
        }}
        
        reduce = %Q{
            function(key, values) {
                var result = {
                    qty: 0,
                    value: 0.0
                };
                
                values.forEach(function(value) {
                    result.qty += value.qty;
                    result.value += value.value;
                });
                
                return result;
            }
        }

        @tags = SalesAggregate.
                    where(tag: /.*\b#{params[:q]}.*/).
                    map_reduce(map, reduce).
                    out(inline: true);

        respond_to do |format|
            format.json # tags.json.jbuilder
        end
    end

    # GET /sales_aggregates/links.json
    # Alias: GET /links.json
    def links
        @sales_aggregates = SalesAggregate

        if params.length == 0
            @sales_aggregates = @sales_aggregates.all
        end
        
        if params.has_key?(:tag)
            @sales_aggregates = @sales_aggregates.where(tag: params[:tag])
        end
    
        @locale = nil
        if params.has_key?(:locale)
            @locale = Locale.find_by(name: params[:locale])
        
            @sales_aggregates = @sales_aggregates.
                or({ made_in: @locale}, { sold_in: @locale })
        end
        
        @locales = nil
        @totals = nil
        if (params.has_key?(:tag) or not @locale.nil?)
            map = %Q{ function() { 
                emit(this.made_in_id, { qty_bought: 0, qty_sold: this.qty, value_bought: 0.0, value_sold: this.value }); 
                emit(this.sold_in_id, { qty_bought: this.qty, qty_sold: 0, value_bought: this.value, value_sold: 0 }); 
            }}
            
            reduce = %Q{
                function(key, values) {
                    var result = {
                        qty_bought: 0,
                        qty_sold: 0,
                        value_bought: 0,
                        value_sold: 0.0
                    };
                    
                    values.forEach(function(value) {
                        result.qty_bought += value.qty_bought;
                        result.qty_sold += value.qty_sold;
                        result.value_bought += value.value_bought;
                        result.value_sold += value.value_sold;
                    });
                    
                    return result;
                }
            }
        
            @locales = @sales_aggregates.
                map_reduce(map, reduce).
                out(inline: true)
            
            qty_bought = 0
            qty_sold = 0
            value_bought = 0.0
            value_sold = 0.0

            local_qty_bought = 0
            local_value_bought = 0.0
            local_qty_sold = 0
            local_value_sold = 0.0

            @locales.each do |loc|
                db_loc = Locale.find(loc["_id"])
                
                qty_bought += loc["value"]["qty_bought"]
                qty_sold += loc["value"]["qty_sold"]
                value_bought += loc["value"]["value_bought"]
                value_sold += loc["value"]["value_sold"]
                
                if not @locale.nil? and db_loc == @locale
                    local_qty_bought = loc["value"]["qty_bought"]
                    local_qty_sold = loc["value"]["qty_sold"]
                    local_value_bought = loc["value"]["value_bought"]
                    local_value_sold = loc["value"]["value_sold"]
                end
                
                loc["value"]["lat"] = db_loc.lat
                loc["value"]["long"] = db_loc.long
            end
            
            @totals = Hash[
                "global" => Hash[
                    "qty_bought" => qty_bought,
                    "qty_sold" => qty_sold,
                    "value_bought" => value_bought,
                    "value_sold" => value_sold
                ],
                "local" => Hash[
                    "qty_bought" => local_qty_bought,
                    "qty_sold" => local_qty_sold,
                    "value_bought" => local_value_bought,
                    "value_sold" => local_value_sold
                ]
            ]
        end

        if params.has_key?(:sort_by)
            if params[:sort_by] == "qty"
                sort_by = :qty
            elsif params[:sort_by] == "value"
                sort_by = :value
            end

            sort_dir = :desc
            if params.has_key?(:sort_dir) and params[:sort_dir] == "asc"
                sort_dir = :asc
            end
        
            if sort_dir == :asc
                @sales_aggregates = @sales_aggregates.asc(sort_by);
            else
                @sales_aggregates = @sales_aggregates.desc(sort_by);
            end
        end

        respond_to do |format|
            format.json # links.json.jbuilder
        end
    end
end
