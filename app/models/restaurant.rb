class Restaurant < ApplicationRecord
  has_many :meals, dependent: :destroy
  validates :name, presence: true
  validates :address, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def self.available(nearby_restaurants)
    now = Time.now.strftime("%u%H%M") # => 21530
    # place.hours = "30900-31200,31400-31800,40900-41200,..."
    opened_restaurants = []
    nearby_restaurants.each do |place|
      if place.opening_hours?
        ranges = place.opening_hours.split(",")
        # ranges = ["30900-31200", "31400-31800", ..]
        ranges.each do |range_string|
          range_splitted = range_string.split("-")
          # range = (range_splitted[0], range_splitted[1])

          opened_restaurants << place if now.between?(range_splitted[0], range_splitted[1])
        end
      end
    end
    p Restaurant.count
    opened_restaurants.each do |e|
      p e.name
    end
  end

end
