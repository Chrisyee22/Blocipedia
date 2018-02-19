# Create users
5.times do
  User.create!(
  username:  Faker::Internet.unique.user_name(6..12),
  email:     Faker::Internet.unique.safe_email,
  password:  Faker::Internet.password(10, 20)
  )
end
users = User.all

# Create wikis
15.times do
  Wiki.create!(
  title:     Faker::Simpsons.character,
  body:      Faker::Simpsons.quote,
  user:      users.sample,
  private:   [true, false].sample

  )
end
wikis = Wiki.all


puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
