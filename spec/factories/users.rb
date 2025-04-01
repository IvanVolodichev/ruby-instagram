FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { '123456' }
    username { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
  end
end