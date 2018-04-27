class Order < ApplicationRecord
  enum payment_status: [ :pending, :paid ]
  enum order_status: [ :active, :canceled ]
  belongs_to :user
  belongs_to :meal
  # monetize :amount_cents
  monetize :price_cents

end
