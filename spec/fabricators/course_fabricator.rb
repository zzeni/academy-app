require 'faker'

Fabricator(:course) do
  name  Faker::Lorem.sentence(3)
  level [1, 2, 3].sample()
end
