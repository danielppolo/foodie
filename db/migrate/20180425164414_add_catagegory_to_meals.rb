class AddCatagegoryToMeals < ActiveRecord::Migration[5.1]
  def change
    add_column :meals, :category, :string
  end
end
