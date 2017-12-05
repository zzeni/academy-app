Fabricator(:student) do
  first_name Faker::Name.first_name
  last_name  Faker::Name.last_name
  email      "user@example.com"
  password   "123456"
end
