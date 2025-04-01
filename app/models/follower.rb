class Follower < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :following, class_name: "User"

  validates :follower_id, uniqueness: { scope: :following_id, message: "Вы уже подписаны на этого пользователя" }

  validate :cannot_follow_self

  private

  def cannot_follow_self
    if follower_id == following_id
      errors.add(:base, "Нельзя подписаться на самого себя")
    end
  end
end