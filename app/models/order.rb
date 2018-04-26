class Order < ApplicationRecord
  enum payment_status: [ :pending, :paid ]
  enum order_status: [ :active, :canceled ]
  belongs_to :user
  belongs_to :meal
  validates :name, uniqueness: :true
  #undo
  memento_changes :destroy
end
