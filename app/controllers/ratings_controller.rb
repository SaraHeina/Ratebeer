
class RatingsController < ApplicationController

  def index
    # Expires joka 15 minuutti.
    Rails.cache.write("beer top 3", Beer.top(3), expires_in:15.minutes) if not_in_cache
    Rails.cache.write("brewery top 3", Brewery.top(3), expires_in:15.minutes) if not_in_cache
    Rails.cache.write("user top 3", User.top(3), expires_in:15.minutes) if not_in_cache
    Rails.cache.write("style top 3", Style.top(3), expires_in:15.minutes) if not_in_cache

    @top_beers = Rails.cache.read "beer top 3"
    @top_breweries = Rails.cache.read "brewery top 3"
    @top_users = Rails.cache.read "user top 3"
    @top_styles = Rails.cache.read "style top 3"
    @ratings = Rating.all
    #@top_beers = Beer.top 3
    #@top_users = User.top 3
    #@top_breweries = Brewery.top 3
    #@top_styles = Style.top 3
  end

  # tarkistaa löytyykö kaikki cachesta
  def not_in_cache
    fragment_exist?( "brewery top 3" )
    fragment_exist?( "beer top 3" )
    fragment_exist?( "user top 3" )
    fragment_exist?( "style top 3" )
  end

  # Päivittää taustalla, ei käytössä
  def background_updater
    while true do
      sleep 25.minutes
      Rails.cache.write("beer top 3", Beer.top(3))
      Rails.cache.write("brewery top 3", Brewery.top(3))
      Rails.cache.write("style top 3", Style.top(3))
      Rails.cache.write("user top 5", User.top(5))
    end
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if current_user.nil?
      redirect_to signin_path, notice:'you should be signed in'
    elsif @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end


  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end

end