class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :likes
  has_many :comments

  validates :images, presence: true
  validates :description, presence: true
end
