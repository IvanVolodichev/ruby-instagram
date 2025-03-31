class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :images, presence: true, content_type: [ "image/png", "image/jpeg" ], size: { less_than: 5.megabytes }
  validates :description, presence: true
end