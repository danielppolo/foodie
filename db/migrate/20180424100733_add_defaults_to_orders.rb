class AddDefaultsToOrders < ActiveRecord::Migration[5.1]
  def change
    change_column_null :orders, :order_status, false
    change_column_default :orders, :order_status, 0
  end
end
