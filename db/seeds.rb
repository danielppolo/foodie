require 'open-uri'


Meal.delete_all
Restaurant.delete_all

city = "milano"
BASE = "https://www.foodora.it/en"
city_url = "https://www.foodora.it/en/city/#{city}"
n_restaurants = 3
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
    restaurant.name = element.text.strip
  end
  # puts "Price/Cuisines"
  rest_doc.search('.vendor-cuisines li:last-child').each do |element|
    # puts "First child is price. Needs to improve"
    restaurant.category = element.text.strip
  end
  # puts "Address"
  rest_doc.search('.vendor-location').each do |element|
    restaurant.address = element.text.strip
  end
  # puts "Hours"
  rest_doc.search('.vendor-delivery-times li').each do |element|
    # puts element.text.strip
  end
  restaurant.save

  rest_doc.xpath("//div[contains(@class, 'dish-card')]").each do |element|
  puts "Meal n.#{i}"
    meal = Meal.new
    meal.restaurant = restaurant
    # puts "Name"
    meal.name = element.search('.dish-name span').text.strip
    # puts "Price"
    meal.price = element.search('.price').text.strip.to_f
    puts meal.price
    # puts "Description"
    meal.description = element.search('.dish-description').text.strip
    # puts "Photo"
    if element.xpath("picture").any?
      photo_values = element.search('.photo').attribute('data-src').value
      photo_url = photo_values.match(/(http:.+)/)[1]
      meal.photo = photo_url
    end
    meal.save
    i += 1
  end
  puts "----------------------------------------"
end

puts "SEEDS are done!"
