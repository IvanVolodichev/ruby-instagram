class LikesController < ApplicationController
  before_action :set_post

  def create
    @post.likes.create(user_id: current_user.id)
    respond_to do |format|
      format.json { render json: { liked: true, likes_count: @post.likes.count } }
    end
  end

  def destroy
    like = @post.likes.find_by(user_id: current_user.id)
    like.destroy if like
    respond_to do |format|
      format.json { render json: { liked: false, likes_count: @post.likes.count } }
    end
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end
end
