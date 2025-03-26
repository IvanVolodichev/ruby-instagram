class FollowersController < ApplicationController
  def follow
    @follow = Follower.new(follower_id: current_user.id, following_id: params[:id])

    if @follow.save
      redirect_to user_posts_path(user_id: params[:id]), notice: "Вы подписались на аккаунт"
    else
      redirect_to user_posts_path(user_id: params[:id]), alert: "Что-то пошло не так при подписке"
    end
  end

  def unfollow
    @follow = Follower.find_by(follower_id: current_user.id, following_id: params[:id])
    if @follow.destroy
      redirect_to user_posts_path(user_id: params[:id]), notice: "Вы успешно отписались"
    else
      redirect_to user_posts_path(user_id: params[:id]), alert: "Что-то пошло не так при отписке"
    end
  end

  def followers
    @user = User.find(params[:id])
    @followers = @user.followers
    render :json => @followers
  end

  def following
    @user = User.find(params[:id])
    @subscribes = @user.following
    render :json => @subscribes
  end
end
