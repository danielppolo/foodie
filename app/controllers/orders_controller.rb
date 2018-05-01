class OrdersController < ApplicationController
   before_action :authenticate_user!

  def index
    @order = current_user.orders.where(state: 1).find(params[:id])
  end

  def new
    @meal = Meal.find(params[:meal_id])
    @order = Order.new
    @lat = cookies[:lat].to_f #I did not have lat either lng that why I did this, able to delete
    @lng = cookies[:lng].to_f #I did not have lat either lng that why I did this, able to delete
    if @meal.restaurant.latitude
      @distance_to = @meal.restaurant.distance_from([@lat, @lng]).round(2)
      @time_to = ((@distance_to*60) / 4.5).round(0)
    end
  end

  def show
    @meal = Meal.find(params[:meal_id])
    @order.meal = @meal
  end

  def create
    @meal = Meal.find(params[:meal_id])
    @time = Time.now
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



    # create_table "orders", force: :cascade do |t|
    # t.date "date"
    # t.integer "order_status", default: 0, null: false
    # t.bigint "user_id"
    # t.bigint "meal_id"
    # t.datetime "created_at", null: false
    # t.datetime "updated_at", null: false
    # t.jsonb "payment"
    # t.integer "payment_status", default: 0, null: false


#   def new
#     @order = Order.new
#     @meal = Meal.find(params[:meal_id])
#   end

#   def create
#   @order = Order.new #Damian's tecnique
#   @order.meal = Meal.find(params[:meal_id])
#   @order.user = current_user
#   @order.save
# end
# def edit
#   @order = Order.find(params[:id])

# end
# def update
#   @order = Order.find(params[:id])

end


