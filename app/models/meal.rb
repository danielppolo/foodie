class Meal < ApplicationRecord
  belongs_to :restaurant
  validates :price_cents, presence: true
  validates :name, presence: true, uniqueness: { scope: :restaurant }
  validates :description, presence: true
  validates :photo, presence: true
  monetize :price_cents

  def self.filter(filter_params)
    if filter_params[:min_price] && filter_params[:max_price]
      price_filter_array = []
      randomized_price_all_meals = []
      min_price = (filter_params[:min_price].to_i)*100
      max_price = (filter_params[:max_price].to_i)*100
      range = (min_price..max_price)
      meals_by_price = Meal.where(price_cents: range)
      meals_by_price.each do |one_meal_by_price|
        price_filter_array << one_meal_by_price
      end
      price_filter_array.shuffle
    end

    if filter_params[:randomize]
      array_all_meals = []
      randomized_array_all_meals = []
      all_meals = Meal.all
      all_meals.each do |one_meal_random|
        array_all_meals << one_meal_random
      end
      array_all_meals.shuffle
    end

    if filter_params[:category]
      query = filter_params[:category]
      restaurants = Restaurant.all.select do |r|
        r.category.include?(query)
      end
      restaurants.shuffle
    end
    self.all
  end

  def self.categories(number_of_results)
    categories = []
    Restaurant.all.each {|r| r.category.split(",").each { |c| categories << c } }
    counts = Hash.new 0
    categories.each { |word| counts[word] += 1 }
    counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
  end

end
