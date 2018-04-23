class Restaurant < ApplicationRecord
  has_many :meals, dependent: :destroy
end
