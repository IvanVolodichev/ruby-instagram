FactoryBot.define do
  factory :follow_relationship, class: 'Follower' do
    association :follower, factory: :user
    association :following, factory: :user
  end
end