FactoryBot.define do
  factory :comment do
    post
    user
    text { Faker::Lorem.paragraph(sentence_count: 2) }
  end
end