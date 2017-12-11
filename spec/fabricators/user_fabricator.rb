Fabricator(:user) do
  email { Faker::Internet.email }
  password 'password'
  full_name { Faker::Name.name }
  admin false
end

# `from: :user` => inherit all the attributes from user
Fabricator(:admin, from: :user) do
  admin true
end