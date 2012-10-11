class EtsySalesAggregatesController < ApplicationController
  # GET /etsy_sales_aggregates
  # GET /etsy_sales_aggregates.json
  def index
    @etsy_sales_aggregates = EtsySalesAggregate.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @etsy_sales_aggregates }
    end
  end

  # GET /etsy_sales_aggregates/1
  # GET /etsy_sales_aggregates/1.json
  def show
    @etsy_sales_aggregate = EtsySalesAggregate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @etsy_sales_aggregate }
    end
  end

  # GET /etsy_sales_aggregates/new
  # GET /etsy_sales_aggregates/new.json
  def new
    @etsy_sales_aggregate = EtsySalesAggregate.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @etsy_sales_aggregate }
    end
  end

  # GET /etsy_sales_aggregates/1/edit
  def edit
    @etsy_sales_aggregate = EtsySalesAggregate.find(params[:id])
  end

  # POST /etsy_sales_aggregates
  # POST /etsy_sales_aggregates.json
  def create
    @etsy_sales_aggregate = EtsySalesAggregate.new(params[:etsy_sales_aggregate])

    respond_to do |format|
      if @etsy_sales_aggregate.save
        format.html { redirect_to @etsy_sales_aggregate, notice: 'Etsy sales aggregate was successfully created.' }
        format.json { render json: @etsy_sales_aggregate, status: :created, location: @etsy_sales_aggregate }
      else
        format.html { render action: "new" }
        format.json { render json: @etsy_sales_aggregate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /etsy_sales_aggregates/1
  # PUT /etsy_sales_aggregates/1.json
  def update
    @etsy_sales_aggregate = EtsySalesAggregate.find(params[:id])

    respond_to do |format|
      if @etsy_sales_aggregate.update_attributes(params[:etsy_sales_aggregate])
        format.html { redirect_to @etsy_sales_aggregate, notice: 'Etsy sales aggregate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @etsy_sales_aggregate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /etsy_sales_aggregates/1
  # DELETE /etsy_sales_aggregates/1.json
  def destroy
    @etsy_sales_aggregate = EtsySalesAggregate.find(params[:id])
    @etsy_sales_aggregate.destroy

    respond_to do |format|
      format.html { redirect_to etsy_sales_aggregates_url }
      format.json { head :no_content }
    end
  end
end
