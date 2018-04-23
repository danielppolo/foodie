class OrdersController < ApplicationController

def new
  @order = Order.new
  @meal = Meal.find(params[:meal_id])

end

def create
  @order = Order.new(order_params)
  @order.meal = Meal.find(params[:meal_id])
  @order.user = current_user

end
private

def order_params
  params.require(:order).permit(:status)

end

end
