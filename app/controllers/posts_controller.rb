class PostsController < ApplicationController
  before_action :set_post, only: [ :edit, :update, :show, :destroy ]
  before_action :check_owner, only: [ :edit, :update, :destroy ]

  def index
    @user = User.find(params[:user_id])
    @posts = Post.where(user_id: @user.id).order(created_at: :desc)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to @post, notice: "Пост был успешно создан!"
    else
      render "new", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
      if @post.update(post_params)
        redirect_to @post, notice: "Пост был успешно обновлён!"
      else
        redirect_to @post, alert: "Произошла ошибка при обновлении"
      end
  end

  def destroy
    if @post.destroy
      redirect_to root_path, notice: "Пост был успешно удалён!"
    else
      redirect_to root_path, alert: "Произошла ошибка при удалении"
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def check_owner
    if @post.user_id != current_user.id
      redirect_to @post, alert: "Вы не являетесь владельцем данного поста"
    end
  end

  def post_params
    params.require(:post).permit(:description, images: [])
  end
end
