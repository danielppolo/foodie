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
