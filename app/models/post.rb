class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :likes
  has_many :comments

end
