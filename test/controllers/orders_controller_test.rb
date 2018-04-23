require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest

def new
  @order = Order.new
  authorize @order
  @meal = Meal.find(params[:meal_id])

end

def create
  @order = Order.new(order_params)
  @order.meal = Meal.find(params[:meal_id])
  @order.user = current_user
  authorize @order
end

end
