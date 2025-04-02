class FollowersController < ApplicationController
  before_action :no_self_follow, only: [ :follow ]

  def follow
    @follow = Follower.find_or_initialize_by(follower_id: current_user.id, following_id: params[:user_id])

    if @follow.new_record? && @follow.save
      redirect_to user_posts_path(user_id: params[:user_id]), notice: "Вы подписались на аккаунт"
    else
      redirect_to user_posts_path(user_id: params[:user_id]), alert: "Не удалось подписаться"
    end
  end

  def unfollow
    @follow = Follower.find_by(follower_id: current_user.id, following_id: params[:user_id])

    if @follow
      @follow.destroy
      redirect_to user_posts_path(user_id: params[:user_id]), notice: "Вы успешно отписались"
    else
      redirect_to user_posts_path(user_id: params[:user_id]), alert: "Что-то пошло не так при отписке"
    end
  end

  def no_self_follow
    if current_user.id.to_s == params[:user_id]
      redirect_to user_posts_path(user_id: params[:user_id]), alert: "Нельзя подписаться на самого себя"
    end
  end
end
