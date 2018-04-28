# restaurants = Restaurant.all
# category = []
# restaurants.each do 	|restaurant|
# 	category << restaurant.category.split(",")
# end
# category = category.flatten.uniq


restaurants = Restaurant.all
category = []
restaurants.each do 	|restaurant|
	temp_array = []
	temp_array = restaurant.category.split(",")
	temp_array.each do |split_cat|
		if 	category.find { |item| item[:name] == "#{split_cat}" }
			category[:count] += 1
		else
			temp_hash = { :count => 1, :name => "#{split_cat}" }
			category << temp_hash
		end
	end
end
category.sort_by!(&:count)