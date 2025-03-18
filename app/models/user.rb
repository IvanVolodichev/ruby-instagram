class User < ApplicationRecord
  has_many :posts
  devise   :database_authenticatable, :registerable, :validatable
end
