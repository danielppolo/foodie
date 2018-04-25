class Meal < ApplicationRecord
  belongs_to :restaurant
  validates :price_cents, presence: true
  validates :name, presence: true, uniqueness: { scope: :restaurant }
  validates :description, presence: true
  validates :photo, presence: true
  monetize :price_cents

  def self.filter(filter_params)
    meals = []
    if filter_params[:min_price] && filter_params[:max_price]
      min_price = (filter_params[:min_price].to_i)*100
      max_price = (filter_params[:max_price].to_i)*100
      range = (min_price..max_price)
      meals_by_price = Meal.where(price_cents: range)
      meals_by_price.each do |one_meal_by_price|
        meals << one_meal_by_price
      end
    end

    if filter_params[:randomize] == true
      Meal.all.shuffle.each { |meal| meals << meal }
    end

    if filter_params[:category]
      query = filter_params[:category]
      restaurants = Restaurant.all.each do |r|
        if r.category.include?(query)
          r.meals.each { |m| meals << m }
        end
      end
    end

    if filter_params[:lat] && filter_params[:lng]
      restaurants = Restaurant.near([filter_params[:lat].to_f, filter_params[:lng].to_f], 2)
      restaurants.each { |r| r.meals.each { |m| meals << m } }
    end
    meals.uniq
  end

  def self.categories(number_of_results)
    categories = []
    Restaurant.all.each {|r| r.category.split(",").each { |c| categories << c } }
    counts = Hash.new 0
    categories.each { |word| counts[word] += 1 }
    counts.sort_by { |_key, value| value }.reverse.to_h.keys.first(number_of_results)
  end

end
