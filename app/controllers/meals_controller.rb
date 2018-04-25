require 'pry'
class MealsController < ApplicationController

	before_action :set_meal, only: [:show]

  def index
    @categories = Meal.categories(10)
    @lat = cookies[:lat]
    @lng = cookies[:lng]
    @meals = Meal.filter(params, cookies)
    # binding.pry
  end

  def show
    # @meal = Meal.find(params[:meal_id])
  end

  def search

  end

  private

  def set_meal
    @meal = Meal.find(params[:id])
  end
end

# def cat_meal(num)
#   restaurants = Restaurant.all
#   hash1 = {}
#   restaurants.each do |restaurant|
#     restaurant.category
#     restaurant_category_array = restaurant.category.split(",")
#     restaurant_category_array.each do |single_category|
#       hash1["#{single_category}"].nil? ? hash1["#{single_category}"] = 1 : hash1["#{single_category}"] += 1
#     end
#   end
#   return hash1.sort_by { |keys, values| values }.reverse!.first(num)
# end


