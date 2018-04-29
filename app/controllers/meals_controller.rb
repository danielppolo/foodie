class MealsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :filter]

  def filter
    @cookies = cookies
    @categories = Meal.categories(12)
    radius_search = user_signed_in? ? current_user.radius_search : 10
    @nearby_categories = Meal.nearby_categories(12, cookies, radius_search)
    @lat = cookies[:lat]
    @lng = cookies[:lng]
  end

  def index
    @lat = cookies[:lat]
    @lng = cookies[:lng]
    radius_search = user_signed_in? ? current_user.radius_search : 10
    # @meals = Meal.filter(params, cookies, radius_search).first(10)
    @meals = Meal.all.shuffle.first(10)
  end


end
