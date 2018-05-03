class Meal < ApplicationRecord
  belongs_to :restaurant
  validates :price_cents, presence: true
  validates :name, presence: true, uniqueness: { scope: :restaurant }
  validates :description, presence: true
  validates :photo, presence: true
  monetize :price_cents

  def available?
    self.restaurant.open?
  end

  def self.filter(params, cookies, search_radius) # => Returns array of Display Meals
    # available = by_location(cookies, search_radius)
    available = by_time(by_location(cookies, search_radius))
    if params[:max_price]
      available = by_price(available, params)
    end
    if params[:category]
      available = by_category(available, params)
    end
    if params[:randomize]
      available = randomize(available)
    end
    available
  end

  def self.by_location(cookies, search_radius) # => Returns array of nearby Meals
  	search_radius = 10
    nearby_meals = []
    r = Restaurant.where("latitude != 0 AND longitude != 0").near([cookies[:lat].to_f, cookies[:lng].to_f], search_radius)
    r.each { |r| r.meals.each { |m| nearby_meals << m } }
    nearby_meals
  end

  def self.by_time(meal_array) # => Returns an array of OpenNow Meals
    meal_array.select { |m| m.available? }
  end

  def self.randomize(meal_array)
    meal_array.shuffle
  end

  def self.by_price(meal_array, params)
    meal_array.select do |m|
      m.price.to_i.between?(0, params[:max_price].to_i)
    end
  end
  # # BY RESTAURANT
  # def self.by_category(meal_array, params)
  #   meal_array.select do |m|
  #     m.restaurant.category.include?(params[:category])
  #   end
  # end

  # BY MEAL
  def self.by_category(meal_array, params)
    meal_array.select do |m|
      m.category.downcase.include?(params[:category])
    end
  end

  def self.by_other(meal_array, params)
    meal_array.select do |m|
      m.description.include?(params[:category])
    end
  end

# BY MEAL CATEGORY
  def self.categories(number_of_results)
    words = []
    Meal.all.each {|m| m.category.split(" ").each { |w| words <<  w if w.length > 3 } }
    counts = Hash.new(0)
    words.each { |word| counts[word] += 1 }
    counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
  end

  def self.nearby_categories(number_of_results, cookies, search_radius)
    categories = []
    Restaurant.near([cookies[:lat].to_f, cookies[:lng].to_f], search_radius).each do |r|
      r.meals.each do |m| m.category.split(" ").each { |c| categories << c if c.length > 3 }
      end
    end
    counts = Hash.new(0)
    categories.each { |word| counts[word] += 1 }
    counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
  end
end





# # BY RESTAURANT CATEGORIES
#   def self.categories(number_of_results)
#     categories = []
#     Restaurant.all.each {|r| r.category.split(",").each { |c| categories << c } }
#     counts = Hash.new(0)
#     categories.each { |word| counts[word] += 1 }
#     counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
#   end

#   def self.nearby_categories(number_of_results, cookies, search_radius)
#     categories = []
#     Restaurant.near([cookies[:lat].to_f, cookies[:lng].to_f], search_radius).each do |r|
#       r.category.split(",").each { |c| categories << c }
#     end
#     counts = Hash.new(0)
#     categories.each { |word| counts[word] += 1 }
#     counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
#   end

# # BY MEAL NAME
#   def self.categories(number_of_results)
#     words = []
#     Meal.all.each {|m| m.name.split(" ").each { |w| words <<  w if w.length > 3 } }
#     counts = Hash.new(0)
#     words.each { |word| counts[word] += 1 }
#     counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
#   end

#   def self.nearby_categories(number_of_results, cookies, search_radius)
#   end

# # BY MEAL DESCRIPTION
#   def self.categories(number_of_results)
#     categories = []
#     Restaurant.all.each {|r| r.category.split(",").each { |c| categories << c } }
#     counts = Hash.new(0)
#     categories.each { |word| counts[word] += 1 }
#     counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
#   end

