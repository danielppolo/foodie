class Restaurant < ApplicationRecord
  has_many :meals, dependent: :destroy
  validates :name, presence: true
  validates :address, presence: true

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def self.available(restaurants)
    now = Time.now.strftime("%u%H%M") # => 21530
    # place.hours = "30900-31200,31400-31800,40900-41200,..."
    open_now = []
    restaurants.each do |restaurant|
      if restaurant.opening_hours?
        ranges = restaurant.opening_hours.split(",")
        # ranges = ["30900-31200", "31400-31800", ..]
        ranges.each do |range_string|
          range_splitted = range_string.split("-")
          # range = (range_splitted[0], range_splitted[1])
          open_now << restaurant if now.between?(range_splitted[0], range_splitted[1])
        end
      end
    end
    open_now
  end

  def open?
    now = Time.now.strftime("%u%H%M") # => 21530
    # place.hours = "30900-31200,31400-31800,40900-41200,..."
    if self.opening_hours?
      ranges = self.opening_hours.split(",")
      # ranges = ["30900-31200", "31400-31800", ..]
      ranges.any? do |range_string|
        range_splitted = range_string.split("-")
        # range = (range_splitted[0], range_splitted[1])
        now.between?(range_splitted[0], range_splitted[1])
      end
    end
  end

end
