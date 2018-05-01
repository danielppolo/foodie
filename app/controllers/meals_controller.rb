require 'json'
require 'open-uri'

class MealsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :search]

  def search
    @cookies = cookies
    @lat = cookies[:lat]
    @lng = cookies[:lng]
    radius_search = user_signed_in? ? current_user.radius_search : 5
    @nearby_categories = Meal.nearby_categories(9, cookies, radius_search)
    if @lat && @lng && @nearby_categories != []
      @categories = @nearby_categories
    else
      @categories = Meal.categories(9)
    end
    @time = Time.now
  end

  def index
    @lat = cookies[:lat]
    @lng = cookies[:lng]
    radius_search = user_signed_in? ? current_user.radius_search : 5
    # if cookies[:lat] && cookies[:lng]
    #   @meals = Meal.filter(params, cookies, radius_search).first(10)
    # else
      # @meals = Meal.all.shuffle.first(3)
    # end
    # TESTING ROUTE ON STATIC MAP
    @meals = Restaurant.find(357).meals.first(1)
    @paths = {}
    if @lat && @lng
      @meals.each do |m|
        url = 'https://maps.googleapis.com/maps/api/directions/json?origin=' + @lat.to_s + ',' + @lng.to_s + '&destination=' + m.restaurant.latitude.to_s + ',' + m.restaurant.longitude.to_s + '&key=AIzaSyBsCPWcOcjt6XbMm6MOsRretGjkgclnWZk'
        route_serialized = open(url).read
        path = JSON.parse(route_serialized)
        if path["routes"][0]
          points = path["routes"][0]["overview_polyline"]["points"]
          link = URI.escape(points, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
          @paths[m.id] = link
        end
      end
      # raise
    end
  end


end
