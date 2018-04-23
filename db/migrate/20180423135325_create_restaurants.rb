class CreateRestaurants < ActiveRecord::Migration[5.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :category
      t.string :address
      t.string :city
      t.string :description
      t.float :latitude
      t.float :longitude
      t.string :photo

      t.timestamps
    end
  end
end
