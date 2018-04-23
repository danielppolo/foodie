class OrdersController < ApplicationController

def new
  @order = Order.new
  @meal = Meal.find(params[:meal_id])

end

def create
  @order = Order.new(status: "pending") #Damian's tecnique
  @order.meal = Meal.find(params[:meal_id])
  @order.user = current_user
  @order.save

end


end
