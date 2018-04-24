class Meal < ApplicationRecord
  belongs_to :restaurant
  validates :price_cents, presence: true
  validates :name, presence: true
  validates :description, presence: true

  monetize :price_cents
end
