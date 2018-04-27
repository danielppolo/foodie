class MealsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :filter]

  def index
    @categories = Meal.categories(10)
    @lat = cookies[:lat]
    @lng = cookies[:lng]
    @meals = Meal.filter(params, cookies).first(3)
  end

 def filter
 end

end
