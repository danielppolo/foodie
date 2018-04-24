class OrdersController < ApplicationController


def index
@order = current_user.orders.where(state: 1).find(params[:id])
end


  def new
    @order = Order.new
    @meal = Meal.find(params[:meal_id])

  end

def create
  @order = Order.new #Damian's tecnique
  @order.meal = Meal.find(params[:meal_id])
  @order.user = current_user
  @order.save

end


end
