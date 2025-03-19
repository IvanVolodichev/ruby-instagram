class FollowersController < ApplicationController
  def follow
    @follow = Follower.new(follower_id: current_user.id, following_id: params[:id])

    if @follow.save
      redirect_to "/home"
    else
      
    end
  end

  def unfollow
    @follow = Follower.find_by(follower_id: current_user.id, following_id: params[:id])
    @follow.destroy
    redirect_to "/home"
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
