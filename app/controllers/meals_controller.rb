class MealsController < ApplicationController

  before_action :set_meal, only: [:show]

  def index
    @meals = Meal.all
  end

  def show

  end

  private

  def set_meal
    @meal = Meal.find(params[:id])
  end
end
