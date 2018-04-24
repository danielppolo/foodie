class Meal < ApplicationRecord
  belongs_to :restaurant
  validates :price_cents, presence: true
  validates :name, presence: true, uniqueness: { scope: :restaurant }
  validates :description, presence: true

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
      randomized_price_all_meals = price_filter_array.shuffle
      return randomized_price_all_meals
    end

    if filter_params[:randomize]
      array_all_meals = []
      randomized_array_all_meals = []
      all_meals = Meal.all
      all_meals.each do |one_meal_random|
        array_all_meals << one_meal_random
      end
      randomized_array_all_meals = array_all_meals.shuffle
      return randomized_array_all_meals
    end

    self.all
  end


  # def self.filter(filter_params)
  #   if filter_params[:min_price] && filter_params[:max_price]
  #     min_price = (filter_params[:min_price].to_i)*100
  #     max_price = (filter_params[:max_price].to_i)*100
  #     range = (min_price..max_price)
  #     return Meal.where(price_cents: range)
  #   end

  #   if filter_params[:randomize]
  #     array_all_meals = []
  #     randomized_array_all_meals = []
  #     all_meals = Meal.all
  #     all_meals.each do |one_meal|
  #       array_all_meals << one_meal
  #     end
  #     randomized_array_all_meals = array_all_meals.shuffle
  #     return randomized_array_all_meals
  #   end

  #   self.all
  # end


end
