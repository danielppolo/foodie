class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def show
    @orders = current_user.orders
    @lat = cookies[:lat]
    @lng = cookies[:lng]
    @path = {}
    if @orders != []
      @last_restaurant = @orders.last.meal.restaurant
      url = 'https://maps.googleapis.com/maps/api/directions/json?origin=' + @lat.to_s + ',' + @lng.to_s + '&destination=' + @last_restaurant.latitude.to_s + ',' + @last_restaurant.longitude.to_s + '&key=AIzaSyBsCPWcOcjt6XbMm6MOsRretGjkgclnWZk'
      route_serialized = open(url).read
      path = JSON.parse(route_serialized)
      if path["routes"][0]
        points = path["routes"][0]["overview_polyline"]["points"]
        link = URI.escape(points, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
        @path[@orders.last.meal.id] = link
      end
      @final_url = "https://api.mapbox.com/styles/v1/mapbox/streets-v10/static/pin-s-pitch+4A3899(#{@lng},#{@lat}),pin-l-restaurant+4A3899(#{@last_restaurant.longitude},#{@last_restaurant.latitude})#{",path-5+4A3899-1(#{@path[@orders.last.meal.id]})" if @path[@orders.last.meal.id]}/auto/600x400?logo=false&attribution=false&access_token=pk.eyJ1Ijoib2Rwb2xvIiwiYSI6ImNqOXQ0YzY3NTNuOGYzM2xnMTMzN3AwMWgifQ.pylpAlDnFVGkJPfl5-N-ng"
    end
  end


  def edit
  end

  def update
    @user.update(user_params)
    redirect_to user_path
  end

  def destroy
    @user.destroy
    redirect_to new_user_registration_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :second_name, :email, :age, :gender, :radius_search)
  end
end
