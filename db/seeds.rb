# require 'open-uri'

# BASE = "https://www.foodora.it/en"
# MILAN = "https://www.foodora.it/en/city/milano"

# city_file = open(MILAN).read
# city_doc = Nokogiri::HTML(city_file)
# restaurants_links = []

# city_doc.search('.hreview-aggregate').each do |element|
#   # puts element.text.strip
#   r = element.attribute('href').value
#   restaurants_links << r
# end

# url = BASE + restaurants_links[1]
# puts "RESTAURANT DETAILS"
# rest_file = open(url).read
# rest_doc = Nokogiri::HTML(rest_file)
# # puts "Name"
# rest_doc.search('.vendor-name').each do |element|
#   puts element.text.strip
# end
# # puts "Price/Cuisines"
# rest_doc.search('.vendor-cuisines li').each do |element|
#   # puts "First child is price"
#   puts element.text.strip
# end
# # puts "Address"
# rest_doc.search('.vendor-location').each do |element|
#   puts element.text.strip
# end
# # puts "Hours"
# rest_doc.search('.vendor-delivery-times li').each do |element|
#   puts element.text.strip
# end

# puts "/////////////////////////////////////"
# puts "MEALS DETAILS"
# rest_doc.xpath("//div[contains(@class, 'dish-card')]").each do |element|
#   # puts "Name"
#   puts element.search('.dish-name span').text.strip
#   # puts "Price"
#   puts element.search('.price').text.strip
#   # puts "Description"
#   puts element.search('.dish-description').text.strip
#   # puts "Photo"
#   if element.xpath("picture").any?
#     photo_values = element.search('.photo').attribute('data-src').value
#     photo_url = photo_values.match(/(http:.+)/)[1]
#     p photo_url
#   end
#   puts "-----------------------"
# end

require 'open-uri'

city = "milano"
BASE = "https://www.foodora.it/en"
city_url = "https://www.foodora.it/en/city/#{city}"
n_restaurants = 3

city_file = open(city_url).read
city_doc = Nokogiri::HTML(city_file)
restaurants_links = []

city_doc.search('.hreview-aggregate').each do |element|
  # puts element.text.strip
  r = element.attribute('href').value
  restaurants_links << r
end


restaurants_links.first(n_restaurants).each do |suffix|
  url = BASE + suffix
  puts "RESTAURANT DETAILS"
  rest_file = open(url).read
  rest_doc = Nokogiri::HTML(rest_file)
  restaurant = Restaurant.new
  restaurant.city = "Milan"
  puts "Name"
  rest_doc.search('.vendor-name').each do |element|
    restaurant.name = element.text.strip
  end
  puts "Price/Cuisines"
  rest_doc.search('.vendor-cuisines li:last-child').each do |element|
    # puts "First child is price. Needs to improve"
    restaurant.category = element.text.strip
  end
  puts "Address"
  rest_doc.search('.vendor-location').each do |element|
    restaurant.address = element.text.strip
  end
  puts "Hours"
  rest_doc.search('.vendor-delivery-times li').each do |element|
    # puts element.text.strip
  end
  restaurant.save

  puts "/////////////////////////////////////"
  puts "MEALS DETAILS"
  rest_doc.xpath("//div[contains(@class, 'dish-card')]").each do |element|
    meal = Meal.new
    meal.restaurant = restaurant
    puts "Name"
    meal.name = element.search('.dish-name span').text.strip
    puts "Price"
    meal.price = element.search('.price').text.strip.to_f
    puts "Description"
    meal.description = element.search('.dish-description').text.strip
    puts "Photo"
    if element.xpath("picture").any?
      photo_values = element.search('.photo').attribute('data-src').value
      photo_url = photo_values.match(/(http:.+)/)[1]
      meal.photo = photo_url
    end
    meal.save
    puts "-----------------------"
  end
end
