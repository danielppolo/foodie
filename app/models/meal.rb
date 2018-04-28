class Meal < ApplicationRecord
  belongs_to :restaurant
  validates :price_cents, presence: true
  validates :name, presence: true, uniqueness: { scope: :restaurant }
  validates :description, presence: true
  validates :photo, presence: true
  monetize :price_cents

  @search_radius = 10

  def self.filter(params, cookies) # => Returns array of Display Meals
    available = by_location(cookies)
    # available = by_time(by_location(cookies))
    if params[:max_price]
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
    r = Restaurant.near([cookies[:lat].to_f, cookies[:lng].to_f], @search_radius)
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
      m.price.to_i.between?(0, params[:max_price].to_i)
    end
  end

  def self.by_category(meal_array, params)
    meal_array.select do |m|
      m.restaurant.category.include?(params[:category])
    end
  end

  def self.by_other(meal_array, params)
    meal_array.select do |m|
      m.description.include?(params[:category])
    end
  end


  def self.categories(number_of_results)
    categories = []
    Restaurant.all.each {|r| r.category.split(",").each { |c| categories << c } }
    counts = Hash.new(0)
    categories.each { |word| counts[word] += 1 }
    counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
  end

  def self.nearby_categories(number_of_results, cookies)
    categories = []
    Restaurant.near([cookies[:lat].to_f, cookies[:lng].to_f], @search_radius).each do |r|
      r.category.split(",").each { |c| categories << c }
    end
    counts = Hash.new(0)
    categories.each { |word| counts[word] += 1 }
    counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
  end

  def available?
    self.restaurant.open?
  end

  def self.categories_description(number_of_results)
    categories = []
    Restaurant.all.each {|r| r.category.split(",").each { |c| categories << c } }
    counts = Hash.new(0)
    categories.each { |word| counts[word] += 1 }
    counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
  end
end

