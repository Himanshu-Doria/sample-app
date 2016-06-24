User.create!(
	name: "Example User",
	email: "example@railstutorial.org",
	password: "foobarrr",
	password_confirmation: "foobarrr",
	admin: true
)
User.create!(
	name: "Micheal Example",
	email: "micheal@example.com",
	password: "password",
	password_confirmation: "password",
	admin: true
)
User.create!(
	name: "Sterling Archer",
	email: "duchess@example.com",
	password: "password",
	password_confirmation: "password",
	admin: true
)
User.create!(
	name: "Lana Kane",
	email: "hands@example.gov",
	password: "password",
	password_confirmation: "password",
	admin: true
)
User.create!(
	name: "Mallory Archer",
	email: "boss@example.gov",
	password: "password",
	password_confirmation: "password",
	admin: true
)
99.times do |n|
	name = Faker::Name.name
	email = "example-#{n + 1}@railstutorial.org"
	password = "password"
	User.create!(name: name,email: email,password: password,password_confirmation: password)
end	