class AddStateToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :payment_status, :integer, default: "0", null: false
    rename_column :orders, :status, :order_status
  end
end
