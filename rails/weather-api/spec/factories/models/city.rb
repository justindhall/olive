FactoryBot.define do
  factory :city do
    name { Faker::Address.city }
    state { Faker::Address.state }
    country { Faker::Address.country_code }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
