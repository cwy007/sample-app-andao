User.create!(
  name: 'Example User',
  email: 'example@railstutorial.org',
  password: 'foobar',
  password_confirmation: 'foobar'
)

99.times do |n|
  user_params = {
    name: Faker::Name.name,
    email: "example-#{n+1}@railstutorial.org",
    password: 'password',
    password_confirmation: 'password'
  }
  User.create!(user_params)
end