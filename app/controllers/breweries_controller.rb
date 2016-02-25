class BreweriesController < ApplicationController
  before_action :set_brewery, only: [:show, :edit, :update, :destroy]
  before_action :ensure_that_signed_in, except: [:index, :show]
  # GET /breweries
  # GET /breweries.json
  def list
  end

  def index
    @breweries = Brewery.all
    @active_breweries = Brewery.active
    @retired_breweries = Brewery.retired

    order = params[:order] || 'name'

    if order == 'name'
      if session[:last_order] == 'name_a'
        active = @active_breweries.sort_by{ |b| b.name }.reverse
        retired = @retired_breweries.sort_by{ |b| b.name }.reverse
        session[:last_order] = 'name_d'
      else
        active = @active_breweries.sort_by{ |b| b.name }
        retired = @retired_breweries.sort_by{ |b| b.name }
        session[:last_order] = 'name_a'
      end
    elsif order == 'year'
      if session[:last_order] == 'year_a'
        active = @active_breweries.sort_by{ |b| b.year }.reverse
        retired = @retired_breweries.sort_by{ |b| b.year }.reverse
        session[:last_order] = 'year_d'
      else
        active = @active_breweries.sort_by{ |b| b.year }
        retired = @retired_breweries.sort_by{ |b| b.year }
        session[:last_order] = 'year_a'
      end
    else
      active = @active_breweries.sort_by{ |b| b.name }
      retired = @retired_breweries.sort_by{ |b| b.name }
    end
    @active_breweries = active
    @retired_breweries = retired

  end

  # GET /breweries/1
  # GET /breweries/1.json
  def show
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
  end

  # GET /breweries/1/edit
  def edit
  end

  # POST /breweries
  # POST /breweries.json
  def create
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.html { redirect_to @brewery, notice: 'Brewery was successfully created.' }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1
  # PATCH/PUT /breweries/1.json
  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to @brewery, notice: 'Brewery was successfully updated.' }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breweries/1
  # DELETE /breweries/1.json
  def destroy
    @brewery.destroy
    respond_to do |format|
      format.html { redirect_to breweries_url, notice: 'Brewery was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def toggle_activity
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, (not brewery.active)

    new_status = brewery.active? ? "active" : "retired"

    redirect_to :back, notice:"brewery activity status changed to #{new_status}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brewery
      @brewery = Brewery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brewery_params
      params.require(:brewery).permit(:name, :year, :active)
    end

end
