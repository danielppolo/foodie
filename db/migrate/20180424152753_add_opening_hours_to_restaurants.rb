class AddOpeningHoursToRestaurants < ActiveRecord::Migration[5.1]
  def change
    add_column :restaurants, :opening_hours, :string
  end
end
