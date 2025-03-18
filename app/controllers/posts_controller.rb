class PostsController < ApplicationController
  before_action :set_post, only: [ :edit, :update, :show, :destroy ]
  before_action :check_owner, only: [ :edit, :update, :destroy ]

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
      if @post.update(post_params)
        flash[:success] = "Object was successfully updated"
        redirect_to @post
      else
        flash[:error] = "Something went wrong"
        render "edit"
      end
  end

  def destroy
    if @post.destroy
      flash[:success] = "Object was successfully deleted."
      redirect_to root_path
    else
      flash[:error] = "Something went wrong"
      redirect_to @post
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def check_owner
    if @post.user_id != current_user.id
      flash[:error] = "У вас нет прав на удаление этой фотографии"
      redirect_to @post
    end
  end

  def post_params
    params.require(:post).permit(:description, images: [])
  end
end
