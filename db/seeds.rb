puts "Starting Faker..."

User.create!(name: "Admin",
  email: "admin@gmail.com",
  password: "admin000",
  password_confirmation: "admin000",
  admin: true,
  activated: true,
  activated_at: Time.zone.now)

puts "Faker is generating data ... Please wait..."

19.times do |n|
name = Faker::Name.name
email = "example-#{n+1}@gmail.com"
password = "12345678"
User.create!(name: name,
  email: email,
  password: password,
  password_confirmation: password,
  activated: true,
  activated_at: Time.zone.now)
end

puts "Create #{User.count} users!"

users = User.order(:created_at).take(6)
10.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

puts "Create #{Micropost.count} microposts!"

users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
