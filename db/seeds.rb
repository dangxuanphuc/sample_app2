puts "Starting Faker..."

User.create!(name: "Admin",
  email: "admin@gmail.com",
  password: "admin000",
  password_confirmation: "admin000",
  admin: true)

puts "Faker is generating data ... Please wait..."

29.times do |n|
name = Faker::Name.name
email = "example-#{n+1}@gmail.com"
password = "12345678"
User.create!(name: name,
  email: email,
  password: password,
  password_confirmation: password)
end

puts "Create #{User.count} users!"
