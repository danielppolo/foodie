require 'open-uri'
require 'pry'
require 'csv'

Order.delete_all
# User.delete_all
Meal.delete_all
Restaurant.delete_all

city = "toronto"
BASE = "https://www.foodora.se"
city_url = "https://www.foodora.se/city/stockholm"
n_restaurants = 10
mcounter = 0
rcounter = 0
restaurants_links = {}

# # NOKOGIRI
# city_file = open(city_url).read
# city_doc = Nokogiri::HTML(city_file)
# city_doc.search('.hreview-aggregate').each do |element|
#   r = element.attribute('href').value
#   restaurants_links[r] = true
# end

# # SAVE TO CSV
# CSV.open('./stockholm.csv', 'wb+') do |csv|
#   csv << ['restaurant', 'pictures?']
#   restaurants_links.each do |link, pictures|
#     csv << [link, pictures]
#   end
# end

# LOAD CSV
CSV.foreach('./stockholm.csv', {headers: :first_row, header_converters: :symbol}) do |row|
  restaurants_links[row[:restaurant]] = row[:pictures?] == 'true'
end

# SCRAPING
p "#{restaurants_links.count} to crack"
p "-----------"
restaurants_links.each do |suffix, _|
  url = BASE + suffix
  puts "Restaurant-#{rcounter}"
  puts url
  rest_file = open(url).read
  rest_doc = Nokogiri::HTML(rest_file)
  restaurant = Restaurant.new
  restaurant.city = "Stockholm"
    # puts "Name"
    rest_doc.search('.vendor-name').each do |element|
      restaurant.name = element.text.match(/^([^-]*)/)[0].strip
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
    place_url = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=" + query + "+" + city +"&key=AIzaSyBsCPWcOcjt6XbMm6MOsRretGjkgclnWZk"
    place_serialized = open(place_url).read
    place = JSON.parse(place_serialized)
    if place.key?("results")
      if place["results"] != []
        place_id = place["results"][0]["place_id"]
        details_url = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + place_id + "&key=AIzaSyBsCPWcOcjt6XbMm6MOsRretGjkgclnWZk"
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
        element.search('.dish-category-title').text.gsub(/[^\s\w]/,"").strip
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
          # puts "Description"
          meal_i.description = meal.search('.dish-description').text.strip
          # puts "Photo"
          if meal.search("picture").any?
            photo_url = meal.search('.photo').attribute('data-src').value
            base_url = photo_url.match(/(.*\?width=)/)[1]
            size = "600"
            # https://images.deliveryhero.io/image/fd-se/Products/20152.jpg?width=302
            # photo_url = photo_values.match(/(http:.+)/)[1]
            # photo_url = "https://lewagon.gumlet.com/#{URI::encode(photo_url)}?width=800"
            # photo_url = photo_values.gsub("https://euvolo-image", "http://euvolo-image")
            meal_i.photo = base_url + size
          end

          if meal_i.save
            mcounter += 1
          end

        end
      end
      if restaurant.meals != []
        rcounter += 1 if restaurant.save
        restaurants_links[suffix] = true
        p "Restaurant Saved"

      else
        restaurants_links[suffix] = false
      end
      p "#{Meal.count} meals scrapped "
      puts "----------------------------------------"
    end
    CSV.open('./restaurants.csv', 'wb+') do |csv|
      csv << ['restaurant', 'pictures?']
      restaurants_links.each do |link, pictures|
        csv << [link, pictures]
      end
    end
  end

  p "#{rcounter}/#{restaurants_links.count} restaurants saved. "
  p "#{mcounter} meals saved."
