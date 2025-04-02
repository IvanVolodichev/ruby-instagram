class LikesController < ApplicationController
  before_action :set_post, :set_like

  def create
    
    if @like
      render json: 
      { error: "You have already liked this post" }, status: :unprocessable_entity
    else
      @post.likes.create(user_id: current_user.id)
      respond_to do |format|
        format.json { render json: { liked: true, likes_count: @post.likes.count } }
      end
    end
  end

  def destroy
    if @like
      @like.destroy
      respond_to do |format|
        format.json { render json: { liked: false, likes_count: @post.likes.count } }
      end
    else
      render json: 
      { error: "Like does not exist" }, status: :not_found
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_like
    @like = @post.likes.find_by(user_id: current_user.id)
  end
end
