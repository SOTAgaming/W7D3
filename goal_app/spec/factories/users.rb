FactoryBot.define do
  factory :user do
    username { Faker::Internet.username }
    password { '123456' }
  end
end
