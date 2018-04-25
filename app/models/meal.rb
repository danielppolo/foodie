class Meal < ApplicationRecord
  belongs_to :restaurant
  validates :price_cents, presence: true
  validates :name, presence: true, uniqueness: { scope: :restaurant }
  validates :description, presence: true
  validates :photo, presence: true
  monetize :price_cents

  def self.filter(params, cookies) # => Returns array of Display Meals
    available = by_time(by_location(cookies))
    if params[:min_price] && params[:max_price]
      available = by_price(available, params)
    end
    if params[:randomize]
      available = randomize(available)
    end
    if params[:category]
      available = by_category(available, params)
    end
    available.shuffle
  end

  def self.by_location(cookies) # => Returns array of nearby Meals
    nearby_meals = []
    r = Restaurant.near([cookies[:lat].to_f, cookies[:lng].to_f], 6)
    r.each { |r| r.meals.each { |m| nearby_meals << m } }
    nearby_meals
  end

  def self.by_time(meal_array) # => Returns an array of OpenNow Meals
    meal_array.select { |m| m.available? }
  end

  def self.randomize(meal_array)
    filter_meals = meal_array.shuffle
  end

  def self.by_price(meal_array, params)
    meal_array.select do |m|
      m.price.to_i.between?(params[:min_price].to_i, params[:max_price].to_i)
    end
  end

  def self.by_category(meal_array, params)
    meal_array.select do |m|
      m.restaurant.category.include?(params[:category])
    end
  end


  def self.categories(number_of_results)
    categories = []
    Restaurant.all.each {|r| r.category.split(",").each { |c| categories << c } }
    counts = Hash.new 0
    categories.each { |word| counts[word] += 1 }
    counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
  end

  def self.nearby_categories(number_of_results)
    categories = []
    Restaurant.near([cookies[:lat].to_f, cookies[:lng].to_f], 6).each do |r|
      r.category.split(",").each { |c| categories << c }
    end
    counts = Hash.new 0
    categories.each { |word| counts[word] += 1 }
    counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
  end

  def available?
    self.restaurant.open?
  end

end





    # if filter_params[:lat] && filter_params[:lng]
    #   filtered_meals = meals.select { |m| m.restaurant.near([filter_params[:lat].to_f, filter_params[:lng].to_f], 2)}
    # end

  # def self.filter(params)
  #   meals = special_filters(meals, params).select { |m| m.available? }
  #   if params[:lat] && params[:lng]
  #     restaurants = Restaurant.near([params[:lat].to_f, params[:lng].to_f],)
  #      restaurants.each { |r| r.meals.each { |m| meals << m } }
  #   else
  #     Meal.all.shuffle.each { |m| meals << m }
  #   end
  # end

# def self.filters(meals, filter_params)
#     meals = []
#     if filter_params[:min_price] && filter_params[:max_price]
#       min_price = (filter_params[:min_price].to_i)*100
#       max_price = (filter_params[:max_price].to_i)*100
#       range = (min_price..max_price)
#       meals_by_price = Meal.where(price_cents: range)
#       meals_by_price.each do |one_meal_by_price|
#         meals << one_meal_by_price
#       end
#     elsif filter_params[:randomize] == true
#       Meal.all.shuffle.each { |meal| meals << meal }
#     elsif filter_params[:category]
#       query = filter_params[:category]
#       restaurants = Restaurant.all.each do |r|
#         if r.category.include?(query)
#           r.meals.each { |m| meals << m }
#         end
#       end
#     else
#       meals
#     end
#     meals.uniq
#   end
