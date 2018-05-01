class Order < ApplicationRecord
  enum payment_status: [ :pending, :paid ]
  enum order_status: [ :active, :canceled ]
  belongs_to :user
  belongs_to :meal
  monetize :price_cents
  # monetize :amount_cents


  def within_five?
    time_difference = (Time.now.to_i - self.created_at.to_i)/60
    if self.order_status == "active"
      time_difference < 5
      end
  end



end
