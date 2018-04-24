class ChangePriceFromMeals < ActiveRecord::Migration[5.1]
  def change
    remove_column :meals, :price, :float
    add_monetize :meals, :price, currency: { present: false }
  end
end
