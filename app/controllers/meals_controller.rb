class MealsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :filter]

  def filter
    @cookies = cookies
    @categories = Meal.categories(12)
    @nearby_categories = Meal.nearby_categories(12, cookies)
    @lat = cookies[:lat]
    @lng = cookies[:lng]
  end

  def index
    @lat = cookies[:lat]
    @lng = cookies[:lng]
    # @meals = Meal.filter(params, cookies).first(10)
    @meals = Meal.all.first(10)
  end


end
