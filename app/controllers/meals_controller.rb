class MealsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :search]

  def search
    @cookies = cookies
    @lat = cookies[:lat]
    @lng = cookies[:lng]
    radius_search = user_signed_in? ? current_user.radius_search : 5
    @nearby_categories = Meal.nearby_categories(12, cookies, radius_search)
    if @lat && @lng && @nearby_categories != []
      @categories = @nearby_categories
    else
      @categories = Meal.categories(12)
    end
  end

  def index
    @lat = cookies[:lat]
    @lng = cookies[:lng]
    radius_search = user_signed_in? ? current_user.radius_search : 5
    if cookies[:lat] && cookies[:lng]
      @meals = Meal.filter(params, cookies, radius_search).first(20)
    else
      @meals = Meal.all.shuffle.first(10)
    end
  end


end
