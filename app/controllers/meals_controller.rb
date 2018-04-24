class MealsController < ApplicationController

  before_action :set_meal, only: [:show]

  def index
    min_price = (params[:min_price].to_i)*100
    max_price = (params[:max_price].to_i)*100
    range = (min_price..max_price)
    @meals = Meal.where(price_cents: range)
  end

  def show
  end

  def search

  end

  private

  def set_meal
    @meal = Meal.find(params[:id])
  end
end
