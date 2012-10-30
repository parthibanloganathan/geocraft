class SalesAggregatesController < ApplicationController
    respond_to :json

    # GET /sales_aggregates
    # GET /sales_aggregates.json
    def index
        @sales_aggregates = SalesAggregate.all

        respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @sales_aggregates }
        end
    end

    # GET /sales_aggregates/1
    # GET /sales_aggregates/1.json
    def show
        @sales_aggregate = SalesAggregate.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @sales_aggregate }
        end
    end  

    # GET /sales_aggregates/links.json
    def links
        @sales_aggregates = SalesAggregate

        if params.length == 0
            @sales_aggregates = @sales_aggregates.all
        end
        
        if params.has_key?(:tag)
            @sales_aggregates = @sales_aggregates.where(tag: params[:tag])
        end
    
        locale = nil
        if params.has_key?(:locale)
            locale = Locale.find_by(name: params[:locale])
        
            @sales_aggregates = @sales_aggregates.
                or({ made_in: locale}, { sold_in: locale })
        end
        
        sort_by = nil
        if params.has_key?(:sort_by)
            if params[:sort_by] == "qty"
                sort_by = :qty
            elsif params[:sort_by] == "value"
                sort_by = :value
            end
        end
        
        @locales = nil
        @totals = nil
        if (params.has_key?(:tag) or not locale.nil?) and not sort_by.nil?
            if sort_by == :qty
                map = %Q{ function() { 
                    emit(this.made_in_id, { buys: 0, sells: this.qty }); 
                    emit(this.sold_in_id, { buys: this.qty, sells: 0 });
                }}
            elsif sort_by == :value
                map = %Q{ function() { 
                    emit(this.made_in_id, { buys: 0, sells: parseFloat(this.value) }); 
                    emit(this.sold_in_id, { buys: parseFloat(this.value), sells: 0 });
                }}
            end
            
            reduce = %Q{
                function(key, values) {
                    var buys = 0;
                    var sells = 0;
                    
                    values.forEach(function(value) {
                        buys += value.buys;
                        sells += value.sells;
                    });
                    
                    return { buys: buys, sells: sells };
                }
            }
        
            @locales = @sales_aggregates.
                map_reduce(map, reduce).
                out(inline: true)
            
            purchases = 0.0
            sales = 0.0
            local_purchases = nil
            local_sales = nil
            
            @locales.each do |loc|
                db_loc = Locale.find(loc["_id"])
                
                purchases += loc["value"]["buys"]
                sales += loc["value"]["sells"]
                
                if not locale.nil? and db_loc == locale
                    local_purchases = loc["value"]["buys"]
                    local_sales = loc["value"]["sells"]
                end
                
                loc["value"]["lat"] = db_loc.lat
                loc["value"]["long"] = db_loc.long
            end
            
            @totals = Hash[
                "purchases" => purchases,
                "sales" => sales,
                "local_purchases" => local_purchases,
                "local_sales" => local_sales
            ]
        end
    
        if not sort_by.nil?
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
