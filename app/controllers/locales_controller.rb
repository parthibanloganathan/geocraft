class LocalesController < ApplicationController
  respond_to :json

  # GET /locales
  # GET /locales.json
  def index
    @locales = Locale.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @locales }
    end
  end

  # GET /locales/1
  # GET /locales/1.json
  def show
    @locale = Locale.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @locale }
    end
  end
end
