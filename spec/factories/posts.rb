FactoryBot.define do
	factory :post do
    description { Faker::Lorem.paragraph(sentence_count: 2) }
    user

    after(:build) do |post|
      post.images.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'test_image1.jpg')),
        filename: 'test_image1.jpg',
        content_type: 'image/jpeg'
      )
    end
  end
end
