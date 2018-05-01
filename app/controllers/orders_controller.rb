class OrdersController < ApplicationController
   before_action :authenticate_user!

  def index
    @order = current_user.orders.where(state: 1).find(params[:id])
  end

  def new
    @meal = Meal.find(params[:meal_id])
    @order = Order.new
    @lat = cookies[:lat]
    @lng = cookies[:lng]
    @distance_to = @meal.restaurant.distance_from([@lat, @lng]).round(2)
    @time_to = ((@distance_to*60) / 4.5).round(0)
  end

  def show
    # update
    # redirect_to root_path
  end

  def create
    @meal = Meal.find(params[:meal_id])
    @order = Order.new
    @order.meal = @meal
    @order.user = current_user
    @order.price_cents = @meal.price_cents

    customer = Stripe::Customer.create(
      source: params[:stripeToken],
      email:  params[:stripeEmail]
    )

    charge = Stripe::Charge.create(
      customer:     customer.id,   # You should store this customer id and re-use it.
      amount:       @order.price_cents,
      description:  "Payment for table #{@meal.id}",
      currency:     "EUR"
    )

    @order.payment = charge.to_json
    @order.date = Time.now
    # @order.order_status = :pending
    # @order.payment_status =
    @order.save
    redirect_to user_path(current_user)
  end

  def update
    @meal = Meal.find(params[:meal_id])
    @order = Order.find(params[:id])
    @order.update(order_status: params[:order_status])

    # @order.update(order_params)
    redirect_to user_path(current_user)
  end



  private

  # def order_params
  #   params.require(:order).permit(:order_status)
  # end

end


