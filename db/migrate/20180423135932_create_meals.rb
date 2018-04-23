class CreateMeals < ActiveRecord::Migration[5.1]
  def change
    create_table :meals do |t|
      t.references :restaurant, foreign_key: true
      t.string :name
      t.float :price
      t.string :photo
      t.string :description

      t.timestamps
    end
  end
end
