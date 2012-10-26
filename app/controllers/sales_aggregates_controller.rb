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
  
  # GET /sales_aggregates/links.json?tag="artwork"
  def links
    @sales_aggregates = SalesAggregate.where(tag: params[:tag])
  
    respond_to do |format|
      format.json # links.json.jbuilder
    end
  end
end
