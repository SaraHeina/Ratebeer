class PlacesController < ApplicationController
  before_action :set_place, only: [:show]

  def index
  end

  def show
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    session[:last_city] = params[:city]
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end

  private

  def set_place
    @place = find(params[:id])
  end

  def find(id)
    city = session[:last_city]
    BeermappingApi.fetch_places_in(city).each do |place|
      if place.id == id
        return place
      end
    end
  end
end