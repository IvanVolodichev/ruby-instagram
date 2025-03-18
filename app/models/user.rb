class User < ApplicationRecord
  has_many :posts
  has_many :likes
  devise   :database_authenticatable, :registerable, :validatable
end
