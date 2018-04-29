require 'open-uri'
require 'pry'

Order.delete_all
User.delete_all
Meal.delete_all
Restaurant.delete_all

city = "milano"
BASE = "https://www.foodora.it/en"
city_url = "https://www.foodora.it/en/city/#{city}"
n_restaurants = 10
mcounter = 0
rcounter = 0

city_file = open(city_url).read
city_doc = Nokogiri::HTML(city_file)
restaurants_links = []
city_doc.search('.hreview-aggregate').each do |element|
  r = element.attribute('href').value
  restaurants_links << r
end

p "#{restaurants_links.count} to crack"
restaurants_links.each do |suffix|
  url = BASE + suffix
  puts "Restaurant#{rcounter}"
  rest_file = open(url).read
  rest_doc = Nokogiri::HTML(rest_file)
  restaurant = Restaurant.new
  restaurant.city = "Milan"
  # puts "Name"
  rest_doc.search('.vendor-name').each do |element|
    p restaurant.name = element.text.match(/^([^-]*)/)[0].strip
  end
  # puts "Price/Cuisines"
  rest_doc.search('.vendor-cuisines').each do |element|
    restaurant.category = element.text.strip.gsub(/ {2,}/, "").delete("€").gsub(/\n{2,}/, "").gsub("\n", ",")
  end
  # puts "Address"
  rest_doc.search('.vendor-location').each do |element|
    restaurant.address = element.text.strip
  end
  # # puts "Hours"
  query = restaurant.name.strip.delete("-").split(" ").join("+")
  query = URI::encode(query)
  # p query
  place_url = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=" + query + "+" + city +"&key=#{ENV["GOOGLE_PLACES_KEY"]}"
  place_serialized = open(place_url).read
  place = JSON.parse(place_serialized)
  if place.key?("results")
    if place["results"] != []
      place_id = place["results"][0]["place_id"]
      details_url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + place_id + "&key=#{ENV["GOOGLE_PLACES_KEY"]}"
      details_serialized = open(details_url).read
      details = JSON.parse(details_serialized)
      if details.key?("result")
        if details["result"].key?("opening_hours")
          periods =  details["result"]["opening_hours"]["periods"]
          openings = []
          periods.each do |day|
            temp_containter = []
            pfx_open = (day["open"]["day"]+1).to_s
            pfx_close = (day["close"]["day"]+1).to_s
            opening = day["open"]["time"].to_s
            closing = day["close"]["time"].to_s
            #   if day["open"]["day"] == 6
            #     pfx_close = 1.to_s
            #   else
            #     pfx_close = (day["close"]["day"]+2).to_s
            #   end
            # else
            #   pfx_close = (day["close"]["day"]+1).to_s
            # end
            openings << "#{pfx_open + opening}-#{pfx_close + closing}"
            # if closing[0] == 0
          end
          restaurant.opening_hours = openings
          p "Google API Worked for opening hours!"
        end
      end
    end
  end

  if restaurant.opening_hours

    # MEAL CATEGORIES
    meal_categories = rest_doc.xpath("//div[contains(@class, 'dish-category-title')]").map do |element|
      element.search('.dish-category-title').text.strip
    end

    # MEAL LISTS
    meal_lists = rest_doc.xpath("//ul[contains(@class, 'dish-list')]").map do |element|
      element
    end

    # MEALS
    meal_lists.each_with_index do |m, i|
      m.xpath(".//div[contains(@class, 'dish-card')]").each do |meal|
        meal_i = Meal.new
        meal_i.category = meal_categories[i].downcase
        meal_i.restaurant = restaurant
        # puts "Name"
        meal_i.name = meal.search('.dish-name span').text.delete(",").gsub(/\d/, "").strip
        # puts "Price"
        meal_i.price = meal.search('.price').text.strip.to_f
        # puts meal.price
        # puts "Description"
        meal_i.description = meal.search('.dish-description').text.strip
        # puts "Photo"
        if meal.xpath("picture").any?
          photo_values = meal.search('.photo').attribute('data-src').value
          photo_url = photo_values.match(/(http:.+)/)[1]
          meal_i.photo = photo_url
        end

        if meal_i.save
          mcounter += 1
        end

      end
    end
    if restaurant.meals != []
      rcounter += 1 if restaurant.save
      p "Restaurant Saved"
    end
    p "#{Meal.count} meals scrapped "
    puts "----------------------------------------"
  end
end

p "#{rcounter}/#{restaurants_links.count} restaurants saved. "
p "#{mcounter} meals saved."
