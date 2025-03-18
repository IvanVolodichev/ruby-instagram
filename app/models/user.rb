class User < ApplicationRecord
  has_many :posts
  has_many :likes
  has_many :comments
  devise   :database_authenticatable, :registerable, :validatable
end
