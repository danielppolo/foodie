class MealsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :filter]

  def index
    @lat = cookies[:lat]
    @lng = cookies[:lng]
    @meals = Meal.all
  end

 def filter
 end

end
