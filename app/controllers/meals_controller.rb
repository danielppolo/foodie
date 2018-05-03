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
    search_radius = user_signed_in? ? current_user.radius_search : 5
    @paths = {}
    @paths_by_restaurant = {}

    if cookies[:lat] && cookies[:lng]
      @meals = Meal.filter(params, cookies, search_radius).first(2)
      @meals.each do |m|

        if not @paths_by_restaurant[m.restaurant.id]
          url = 'https://maps.googleapis.com/maps/api/directions/json?origin=' + @lat.to_s + ',' + @lng.to_s + '&destination=' + m.restaurant.latitude.to_s + ',' + m.restaurant.longitude.to_s + '&key=AIzaSyBsCPWcOcjt6XbMm6MOsRretGjkgclnWZk'
          route_serialized = open(url).read
          path = JSON.parse(route_serialized)
          @paths_by_restaurant[m.restaurant.id] = path
        end

        route = @paths_by_restaurant[m.restaurant.id]
        if route["routes"][0]
          points = route["routes"][0]["overview_polyline"]["points"]
          link = URI.escape(points, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
          @paths[m.id] = link
        end
      end
    else
        return redirect_to root_path
    end
  end
end
