require 'open-uri'


Meal.delete_all
Restaurant.delete_all

city = "milano"
BASE = "https://www.foodora.it/en"
city_url = "https://www.foodora.it/en/city/#{city}"
n_restaurants = 10
i = 0

Meal.delete_all
Restaurant.delete_all

city_file = open(city_url).read
city_doc = Nokogiri::HTML(city_file)
restaurants_links = []
city_doc.search('.hreview-aggregate').each do |element|
  r = element.attribute('href').value
  restaurants_links << r
end

restaurants_links.first(n_restaurants).each do |suffix|
  url = BASE + suffix
  puts "Restaurant"
  rest_file = open(url).read
  rest_doc = Nokogiri::HTML(rest_file)
  restaurant = Restaurant.new
  restaurant.city = "Milan"
  # puts "Name"
  rest_doc.search('.vendor-name').each do |element|
    restaurant.name = element.text.match(/^([^-]*)/)[0].strip
  end
  # puts "Price/Cuisines"
  rest_doc.search('.vendor-cuisines').each do |element|
    # puts "First child is price. Needs to improve"
    restaurant.category = element.text.strip.gsub(/ {2,}/, "").delete("€").gsub(/\n{2,}/, "").gsub("\n", ",")
  end
  # puts "Address"
  rest_doc.search('.vendor-location').each do |element|
    restaurant.address = element.text.strip
  end
  # # puts "Hours"
  query = restaurant.name.strip.delete("-").split(" ").join("+")
  query = URI::encode(query)
  p query
  place_url = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=" + query + "+" + city +"&key=AIzaSyAA9IHmxRimlkxjzSxOr_PkNsHYMe9NGb8"
  place_serialized = open(place_url).read
  place = JSON.parse(place_serialized)
  if place.key?("results")
    place_id = place["results"][0]["place_id"]
    details_url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + place_id + "&key=AIzaSyAA9IHmxRimlkxjzSxOr_PkNsHYMe9NGb8"
    details_serialized = open(details_url).read
    details = JSON.parse(details_serialized)
    if details["result"].key?("opening_hours")
      periods =  details["result"]["opening_hours"]["periods"]
      openings = []
      periods.each do |day|
      temp_containter = []
      pfx_open = (day["open"]["day"]+1).to_s
      pfx_close = (day["close"]["day"]+1).to_s
      opening = day["open"]["time"].to_s
      closing = day["close"]["time"].to_s
      # if closing[0] == 0
      #   if day["open"]["day"] == 6
      #     pfx_close = 1.to_s
      #   else
      #     pfx_close = (day["close"]["day"]+2).to_s
      #   end
      # else
      #   pfx_close = (day["close"]["day"]+1).to_s
      # end
      openings << "#{pfx_open + opening}-#{pfx_close + closing}"
      restaurant.opening_hours = openings.join(",")
      end
    end
  end
  # rest_doc.search('.vendor-delivery-times li').each do |element|
  #   puts element.text.strip
  # end
  restaurant.save

  # MEALS
  rest_doc.xpath("//div[contains(@class, 'dish-card')]").each do |element|
  # puts "Meal n.#{i}"
    meal = Meal.new
    meal.restaurant = restaurant
    # puts "Name"
    meal.name = element.search('.dish-name span').text.strip
    # puts "Price"
    meal.price = element.search('.price').text.strip.to_f
    # puts meal.price
    # puts "Description"
    meal.description = element.search('.dish-description').text.strip
    # puts "Photo"
    if element.xpath("picture").any?
      photo_values = element.search('.photo').attribute('data-src').value
      photo_url = photo_values.match(/(http:.+)/)[1]
      meal.photo = photo_url
    end
    if meal.save
      i += 1
    end
  end
  p meal.count
  puts "----------------------------------------"
end

puts "Seeds are done!"
