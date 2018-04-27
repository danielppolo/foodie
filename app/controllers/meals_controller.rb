class MealsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :filter]
	before_action :set_meal, only: [:show]

  def index
    @categories = Meal.categories(10)
    @lat = cookies[:lat]
    @lng = cookies[:lng]
    @meals = Meal.all.first(3)
    # binding.pry
  end

  def show
 # USER COORDINATES
 @user_to_restaurant_marker = [{
   lat: cookies[:lat],
   lng: cookies[:lng]
 },
 {
     lat: "#{@meal.restaurant.latitude}",
     lng: "#{@meal.restaurant.longitude}"
  }


  ]

   # RESTURANT COORDINATES

   @restaurant_marker =
   [{
     lat: @meal.restaurant.latitude.to_s,
     lng: @meal.restaurant.longitude.to_s,
   }]
   # @meal = Meal.find(params[:meal_id])  end
 end

 def filter


 end

 private

 def set_meal
  @meal = Meal.find(params[:id])
end
end
