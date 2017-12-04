require 'faker'

Fabricator(:category) do
  name Faker::Lorem.sentence(2)[0..15]
end
