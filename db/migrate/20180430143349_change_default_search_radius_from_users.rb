class ChangeDefaultSearchRadiusFromUsers < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :radius_search, from: 2, to: 5
  end
end
