 require 'faker'

# User.destroy_all
Order.destroy_all
Restaurant.destroy_all
Meal.destroy_all

p "Creatinf Users"
daniel = User.new(email: "daniel@gmail.com", password: 1234567, name: "Daniel", age: 24, gender: 1, radius_search: 3)
fra = User.new(email: "francesco@gmail.com", password: 1234567, name: "Francesco", age: 25, gender: 1, radius_search: 5)
juan = User.new(email: "juan@gmail.com", password: 1234567, name: "Juan", age: 20, gender: 0, radius_search: 1)
daniel.save
fra.save
juan.save
p "Creating restaurants"
cust = [daniel, fra, juan]
res1 = Restaurant.new(name: "Calizza", category: "italian", city: "Milan", address: "Via Aosta 4, Milan", description: "Small and cheap pizza")
res2 = Restaurant.new(name: "Los Chupacabras", category: "mexican", city: "Milan", address: "Via Ampere 2, Milan", description: "Best tacos in town")
res1.save
res2.save

p "Creating food"
uno = Meal.new(name: Faker::Food.dish, description: Faker::RickAndMorty.quote , price: rand(100..1000).round.to_i, restaurant: res1)
dos = Meal.new(name: Faker::Food.dish, description: Faker::RickAndMorty.quote , price: rand(100..1000).round.to_i, restaurant: res1)
tres = Meal.new(name: Faker::Food.dish, description: Faker::RickAndMorty.quote , price: rand(100..1000).round.to_i, restaurant: res1)
cuatro = Meal.new(name: Faker::Food.dish, description: Faker::RickAndMorty.quote , price: rand(100..1000).round.to_i, restaurant: res2)
cinco = Meal.new(name: Faker::Food.dish, description: Faker::RickAndMorty.quote , price: rand(100..1000).round.to_i, restaurant: res2)
seis = Meal.new(name: Faker::Food.dish, description: Faker::RickAndMorty.quote , price: rand(100..1000).round.to_i, restaurant: res2)
uno.save
dos.save
tres.save
cuatro.save
cinco.save
seis.save
food = [uno, dos, tres, cuatro, cinco, seis]
# p food


p "Creating orders"
30.times do
  Order.create(user: cust.sample, meal: food.sample, date: Date.today, status: 0)
end

puts "SEEDS are done!"
