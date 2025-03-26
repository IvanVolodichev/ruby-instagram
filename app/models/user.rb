class User < ApplicationRecord
  devise   :database_authenticatable,
           :registerable,
           :validatable

  has_many :posts
  has_many :likes
  has_many :comments
  has_one_attached :avatar

  # получить список подписчиков
  has_many :follower_relationships, class_name: "Follower", foreign_key: "following_id"
  has_many :followers, through: :follower_relationships, source: :follower

  # получить список подписок
  has_many :following_relationships, class_name: "Follower", foreign_key: "follower_id"
  has_many :following, through: :following_relationships, source: :following

  def liked?(post)
    post.likes.where(user_id: self.id).present?
  end
end
